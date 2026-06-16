/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_server.dart';

class A2AExpressApp {
  final A2ARequestHandler _requestHandler; // Kept for getAgentCard
  final A2AJsonRpcTransportHandler _jsonRpcTransportHandler;

  A2AExpressApp(this._requestHandler, this._jsonRpcTransportHandler);

  /// Adds A2A routes to an existing Darto app.
  /// @param app Optional existing Express app.
  /// @param baseUrl The base URL for A2A endpoints (e.g., "/a2a/api").
  /// @param middlewares Optional array of Darto middlewares to apply to the A2A routes.
  /// @returns The Express app with A2A routes.
  Darto setupRoutes(
    Darto app,
    String baseUrl, {
    List<Middleware>? middlewares,
    String agentCardPath = A2AConstants.agentCardPath,
  }) {
    app.route(baseUrl, (router) {
      if (middlewares != null) {
        for (final middleware in middlewares) {
          router.use(middleware);
        }
      }

      router.get(agentCardPath, [], (Context c) async {
        try {
          // getAgentCard is on A2ARequestHandler, which DefaultRequestHandler implements
          final agentCard = await _requestHandler.agentCard;
          return c.json(agentCard.toJson());
        } catch (e) {
          print(
            '${Colorize('A2AExpressApp::setupRoutes - Error fetching agent card:').red()} $e',
          );
          return c.status(500).json({'error': 'Failed to retrieve agent card'});
        }
      });

      router.post('/', [], (Context c) async {
        dynamic body;
        try {
          final bodyAsString = await c.req.text();
          if (bodyAsString.isNotEmpty) {
            body = json.decode(bodyAsString);
          } else {
            body = {};
          }
        } catch (_) {
          body = await c.req.json();
        }

        try {
          final rpcResponseOrStream = await _jsonRpcTransportHandler.handle(
            body,
          );

          if (rpcResponseOrStream is Function) {
            // The handler returned a stream generator.
            return streamSSE(c, (sse) async {
              try {
                await for (final event in rpcResponseOrStream()) {
                  final jsonData = event.toJson();
                  if (A2AServerDebug.isOn) {
                    final jsonString = A2AServerDebug.printJson(jsonData);
                    print(
                      '${Colorize('A2AExpressApp::setupRoutes - Sending SSE event $jsonString').green()}',
                    );
                  }
                  await sse.writeSSE(SseEvent(data: json.encode(jsonData)));
                }
              } catch (e) {
                print(
                  '${Colorize('A2AExpressApp::setupRoutes - Error during SSE streaming').red()}, '
                  '$e',
                );
              }
            });
          } else {
            // The handler returned a single response.
            final responseMap = (rpcResponseOrStream as dynamic).toJson();
            if (A2AServerDebug.isOn) {
              final jsonString = A2AServerDebug.printJson(responseMap);
              print(
                '${Colorize('A2AExpressApp::setupRoutes - Sending normal response $jsonString').green()}',
              );
            }
            return c.status(200).json(responseMap);
          }
        } on A2APushNotificationNotSupportedError catch (e) {
          print(
            '${Colorize('A2AExpressApp::setupRoutes - Push notifications are not supported').yellow()}',
          );
          final errorResponse = A2AJSONRPCErrorResponse()..error = e;
          return c.status(500).json(errorResponse.toJson());
        } on A2ATaskNotFoundError catch (e) {
          final errorResponse = A2AJSONRPCErrorResponse()..error = e;
          return c.status(500).json(errorResponse.toJson());
        } catch (e) {
          // General error
          print(
            '${Colorize('A2AExpressApp::setupRoutes - Unhandled error in A2AExpressApp POST handler:').red()}, '
            '$e',
          );
          final error = e is A2AServerError
              ? e
              : A2AServerError.internalError('Streaming error.', null);
          final errorResponse = A2AJSONRPCErrorResponse()
            ..error = error as A2AError;
          return c.status(500).json(errorResponse.toJson());
        }
      });
    });

    return app;
  }
}
