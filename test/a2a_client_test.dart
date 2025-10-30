import 'dart:convert';

import 'package:a2a/a2a.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:test/test.dart';

void main() {
  group('A2AClient', () {
    late A2AClient client;
    late Uri serverUrl;

    setUp(() async {
      final handler = const shelf.Pipeline().addHandler((
        shelf.Request request,
      ) {
        if (request.url.path.endsWith('agent-card.json')) {
          return shelf.Response.ok(
            json.encode({
              'protocolVersion': '0.3.0',
              'name': 'Test Agent',
              'description': 'A test agent',
              'version': '1.0.0',
              'url': serverUrl.toString(),
              'capabilities': {'streaming': true},
              'defaultInputModes': [],
              'defaultOutputModes': [],
              'skills': [],
              'preferredTransport': 'JSONRPC',
            }),
            headers: {'Content-Type': 'application/json'},
          );
        }
        if (request.method == 'POST') {
          final sseStreamBody =
              ':this is a comment\n'
              '\n'
              'data: ${json.encode({
                "jsonrpc": "2.0",
                "id": 1,
                "result": {"messageId": "msg1"},
              })}\n'
              '\n'
              ': ping - keep-alive\n'
              '\n'
              'data: ${json.encode({
                "jsonrpc": "2.0",
                "id": 1,
                "result": {"messageId": "msg2"},
              })}\n';

          return shelf.Response.ok(
            sseStreamBody,
            headers: {'Content-Type': 'text/event-stream'},
          );
        }
        return shelf.Response.notFound('Not Found');
      });

      final server = await io.serve(handler, 'localhost', 0);
      serverUrl = Uri.parse('http://${server.address.host}:${server.port}');
      client = A2AClient(serverUrl.toString());
    });

    test(
      'sendMessageStream correctly parses SSE stream with comments and empty lines',
      () async {
        final params = A2AMessageSendParams()
          ..message = (A2AMessage()..parts = [A2ATextPart()..text = 'hello']);

        // We need to wait for the agent card to be fetched before we can send a message.
        await client.getAgentCard();

        final stream = client.sendMessageStream(params);
        final results = await stream.toList();

        expect(results.length, 2);
        expect(results[0].isError, isFalse);
        expect(results[1].isError, isFalse);
      },
    );
  });
}
