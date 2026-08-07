import 'dart:convert';
import 'dart:io';

import 'package:a2a/a2a.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:test/test.dart';

// Client tests
void main() {
  group('A2AClient - SSE parsing', () {
    late A2AClient client;
    late Uri serverUrl;
    late HttpServer server;

    setUp(() async {
      final handler = const shelf.Pipeline().addHandler((
        shelf.Request request,
      ) {
        if (request.url.path.endsWith('agent-card.json')) {
          return shelf.Response.ok(
            json.encode({
              'protocolVersion': '0.3.0',
              'name': 'Test Agent Streaming',
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

      server = await io.serve(handler, 'localhost', 0);
      serverUrl = Uri.parse('http://${server.address.host}:${server.port}');
      client = A2AClient(serverUrl.toString(), agentCardBackgroundFetch: false);
    });

    tearDown(() async {
      await server.close(force: true);
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

  group('A2AClient - Agent Card Validation', () {
    late A2AClient client;
    late Uri serverUrl;
    late HttpServer server;
    final agentCards = List<String>.filled(7, '');
    var agentCardIndex = 0;

    // Main url not present
    agentCards[0] = json.encode({
      'protocolVersion': '0.3.0',
      'name': 'Test Agent Validation 0',
      'description': 'An agent card validation test agent',
      'version': '1.0.0',
      'capabilities': {'streaming': true},
      'defaultInputModes': [],
      'defaultOutputModes': [],
      'skills': [],
      'preferredTransport': 'JSONRPC',
    });

    // Main url empty
    agentCards[1] = json.encode({
      'protocolVersion': '0.3.0',
      'name': 'Test Agent Validation 1',
      'description': 'An agent card validation test agent',
      'version': '1.0.0',
      'url': '',
      'capabilities': {'streaming': true},
      'defaultInputModes': [],
      'defaultOutputModes': [],
      'skills': [],
      'preferredTransport': 'JSONRPC',
    });

    // Preferred transport not JSONRPC
    agentCards[2] = json.encode({
      'protocolVersion': '0.3.0',
      'name': 'Test Agent Validation 2',
      'description': 'An agent card validation test agent',
      'version': '1.0.0',
      'url': 'http://localhost',
      'capabilities': {'streaming': true},
      'defaultInputModes': [],
      'defaultOutputModes': [],
      'skills': [],
      'preferredTransport': 'GRPC',
    });

    // Preferred transport not JSONRPC, no viable additional interface
    agentCards[3] = json.encode({
      'protocolVersion': '0.3.0',
      'name': 'Test Agent Validation 3',
      'description': 'An agent card validation test agent',
      'version': '1.0.0',
      'url': 'http://localhost',
      'capabilities': {'streaming': true},
      'defaultInputModes': [],
      'defaultOutputModes': [],
      'skills': [],
      'preferredTransport': 'GRPC',
      'additionalInterfaces': [
        {'url': 'http://localhost', 'transport': 'GRPC'},
      ],
    });

    // Preferred transport not JSONRPC, additional interface url has more than one transport
    agentCards[4] = json.encode({
      'protocolVersion': '0.3.0',
      'name': 'Test Agent Validation 4',
      'description': 'An agent card validation test agent',
      'version': '1.0.0',
      'url': 'http://localhost',
      'capabilities': {'streaming': true},
      'defaultInputModes': [],
      'defaultOutputModes': [],
      'skills': [],
      'preferredTransport': 'GRPC',
      'additionalInterfaces': [
        {'url': 'http://localhost', 'transport': 'GRPC'},
        {'url': 'http://localhost', 'transport': 'GRPC'},
      ],
    });

    // Preferred transport not JSONRPC, viable additional interface
    agentCards[5] = json.encode({
      'protocolVersion': '0.3.0',
      'name': 'Test Agent Validation 5',
      'description': 'An agent card validation test agent',
      'version': '1.0.0',
      'url': 'http://localhost',
      'capabilities': {'streaming': true},
      'defaultInputModes': [],
      'defaultOutputModes': [],
      'skills': [],
      'preferredTransport': 'GRPC',
      'additionalInterfaces': [
        {'url': 'http://localhost1', 'transport': 'JSONRPC'},
      ],
    });

    // Agent card URL is not absolute
    agentCards[6] = json.encode({
      'protocolVersion': '0.3.0',
      'name': 'Test Agent Validation 6',
      'description': 'An agent card validation test agent',
      'version': '1.0.0',
      'url': '/localhost',
      'capabilities': {'streaming': true},
      'defaultInputModes': [],
      'defaultOutputModes': [],
      'skills': [],
      'preferredTransport': 'JSONRPC',
    });

    setUp(() async {
      final handler = const shelf.Pipeline().addHandler((
        shelf.Request request,
      ) {
        if (request.url.path.endsWith('agent-card.json')) {
          return shelf.Response.ok(
            agentCards[agentCardIndex],
            headers: {'Content-Type': 'application/json'},
          );
        }
        return shelf.Response.notFound('Not Found');
      });
      server = await io.serve(handler, 'localhost', 0);
      serverUrl = Uri.parse('http://${server.address.host}:${server.port}');
      client = A2AClient(serverUrl.toString(), agentCardBackgroundFetch: false);
    });

    tearDown(() async {
      await server.close(force: true);
    });

    test('No url', () async {
      try {
        await client.getAgentCard();
      } catch (e) {
        expect(
          e.toString(),
          'type \'Null\' is not a subtype of type \'String\' in type cast',
        );
      }
      agentCardIndex = 1;
    });
    test('Url empty', () async {
      try {
        await client.getAgentCard();
      } catch (e) {
        expect(
          e.toString(),
          'Exception: fetchAndCacheAgentCard:: Fetched Agent Card does not contain a valid "url" for the service endpoint.',
        );
      }
      agentCardIndex = 2;
    });
    test('Preferred transport not JSONRPC', () async {
      try {
        await client.getAgentCard();
      } catch (e) {
        expect(
          e.toString(),
          'Exception: fetchAndCacheAgentCard:: No interfaces found that support the JSONRPC transport',
        );
      }
      agentCardIndex = 3;
    });
    test('No additional interfaces support JSONRPC', () async {
      try {
        await client.getAgentCard();
      } catch (e) {
        expect(
          e.toString(),
          'Exception: fetchAndCacheAgentCard:: No interfaces found that support the JSONRPC transport',
        );
      }
      agentCardIndex = 4;
    });
    test(
      'No additional interface url supports more than one transport',
      () async {
        try {
          await client.getAgentCard();
        } catch (e) {
          expect(
            e.toString(),
            'Exception: fetchAndCacheAgentCard:: URL "http://localhost" is mapped to more than one transport.',
          );
        }
        agentCardIndex = 5;
      },
    );
    test('Additional interface supports JSONRPC', () async {
      final agentCard = await client.getAgentCard();
      expect(agentCard.preferredTransport, A2ATransportProtocol.jsonRpc);
      expect(agentCard.url, 'http://localhost1');
      expect(agentCard.name, 'Test Agent Validation 5');
      agentCardIndex = 6;
    });
    test('Agent card URL is not absolute', () async {
      try {
        await client.getAgentCard();
      } catch (e) {
        expect(
          e.toString(),
          'Exception: fetchAndCacheAgentCard:: The Agent Card URL supplied is relative, not absolute - [/localhost]',
        );
      }
    });
  });
}
