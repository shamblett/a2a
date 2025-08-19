/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../a2a_server.dart';

class A2AExpressApp {

  final A2ARequestHandler _requestHandler; // Kept for getAgentCard
  final A2AJsonRpcTransportHandler _jsonRpcTransportHandler;

  A2AExpressApp(this._requestHandler, this._jsonRpcTransportHandler);

  /// Adds A2A routes to an existing Darto app.
  /// @param app Optional existing Express app.
  /// @param baseUrl The base URL for A2A endpoints (e.g., "/a2a/api").
  /// @returns The Express app with A2A routes.
  Darto setupRoutes(Darto app, String baseUrl) {
    app.get('$baseUrl/.well-known/agent.json', (
      Request req,
      Response res,
    ) async {
      try {
        // getAgentCard is on A2ARequestHandler, which DefaultRequestHandler implements
        final agentCard = await _requestHandler.agentCard;
        res.json(agentCard.toJson());
      } catch (e) {
        print(
          '${Colorize('A2AExpressApp::setupRoutes - Error fetching agent card:').red()} $e',
        );
        res.status(500).json({'error': 'Failed to retrieve agent card'});
      }
    });

    app.post(baseUrl, (Request req, Response res) async {
      final body = await req.body;
      try {
        final rpcResponseOrStream = await _jsonRpcTransportHandler.handle(body);
        // Check if it's an AsyncGenerator (stream)
        if (rpcResponseOrStream is Function) {
          res.set('Content-Type', 'text/event-stream');
          res.set('Cache-Control', 'no-cache');
          res.set('Connection', 'keep-alive');
          final streamData = <String>[];
          try {
            await for (final event in rpcResponseOrStream()) {
              // Each event from the stream is already a JSONRPCResult
              streamData.add('id:${DateTime.now().millisecondsSinceEpoch}\n');
              streamData.add('data: ${json.encode(event.toJson())}\n\n');
            }
          } catch (e) {
            print(
              '${Colorize('A2AExpressApp::setupRoutes - Error during SSE streaming (request ${body?.id}').red()}, '
              '$e',
            );
            // If the stream itself throws an error, send a final JSONRPCErrorResponse
            final error = e is A2AServerError
                ? e
                : A2AServerError.internalError('Streaming error.', null);
            final errorResponse = A2AJSONRPCErrorResponse()
            ..id = '<error marker>'
              ..error = (error as A2AServerError).toJSONRPCError();
            res.status(500).json(errorResponse.toJson());
          } finally {
            if (!res.finished) {
              res.end(json.encode(streamData));
            }
          }
        } else {
          // Single JSON-RPC response
          res.status(200).json((rpcResponseOrStream as dynamic).toJson());
        }
      } catch (e) {
        print(
          '${Colorize('A2AExpressApp::setupRoutes - Unhandled error in A2AExpressApp POST handler:').red()}, '
          '$e',
        );
        final error = e is A2AServerError
            ? e
            : A2AServerError.internalError('Streaming error.', null);
        final errorResponse = A2AJSONRPCErrorResponse()
          ..error = error as A2AError;
        if (!res.finished) {
          res.status(500).json(errorResponse.toJson());
        }
      }
    });
    return app;
  }
}
