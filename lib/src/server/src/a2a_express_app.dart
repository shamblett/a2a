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
        res.json(agentCard);
      } catch (e) {
        print(
          '${Colorize('A2AExpressApp::setupRoutes Error fetching agent card:').red()} $e',
        );
        res.status(500).json({'error': 'Failed to retrieve agent card'});
      }
    });

    app.post(baseUrl, (Request req, Response res) async {
      final rpcResponseOrStream = await _jsonRpcTransportHandler.handle(
        req.body,
      );

      // Check if it's an AsyncGenerator (stream)
      if (rpcResponseOrStream is Function) {
        res.set('Content-Type', 'text/event-stream');
        res.set('Cache-Control', 'no-cache');
        res.set('Connection', 'keep-alive');

        try {
          await for (final event in rpcResponseOrStream()) {
            // Each event from the stream is already a JSONRPCResult
            res.set('id:', '${DateTime.now().millisecondsSinceEpoch}\n');
            res.set('data:', '${json.encode(event)}\n\n');
          }
        } catch (e) {
        } finally {}
      }
    });
  }
}
