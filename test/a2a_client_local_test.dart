/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

@TestOn('vm')
library;

import 'package:test/test.dart';

import 'package:a2a/a2a.dart';

/// Tests the client against the local 'helloworld' agent located at
/// http://localhost:9999
/// See the README file in test/support/agents/helloworld for more details
/// on how to build and run the agent.
///
/// This agent returns the following JSON for its Agent Card :-
///
/// {'capabilities': {'streaming': True}, 'defaultInputModes': ['text'], 'defaultOutputModes': ['text'],
/// 'description': 'Just a hello world agent', 'name': 'Hello World Agent', 'protocolVersion': '0.2.6', 'skills':
/// [{'description': 'just returns hello world', 'examples': ['hi', 'hello world'], 'id': 'hello_world',
/// 'name': 'Returns hello world', 'tags': ['hello world']}], 'supportsAuthenticatedExtendedCard': True, 'url':
/// 'http://localhost:9999/', 'version': '1.0.0'}

Future<int> main() async {
  A2AClient? testClient;
  const baseUrl = 'http://localhost:9999';

  group('Client Base', () {
    test('Construction', () async {
      testClient = A2AClient(baseUrl);
      await Future.delayed(Duration(seconds: 1));
      expect(testClient!.agentBaseUrl, 'http://localhost:9999');
      expect(await testClient!.serviceEndpoint, 'http://localhost:9999/');
    });
    test('Get Agent Card', () async {
      if (testClient == null) {
        testClient ??= A2AClient(baseUrl);
        await Future.delayed(Duration(seconds: 1));
      }
      final agentCard = await testClient!.getAgentCard(
        agentBaseUrl: 'http://localhost:9999',
      );
      expect(testClient!.agentBaseUrl, 'http://localhost:9999');
      expect(await testClient!.serviceEndpoint, 'http://localhost:9999/');
      expect(agentCard.capabilities.streaming, isTrue);
      expect(agentCard.defaultInputModes, ['text']);
      expect(agentCard.defaultOutputModes, ['text']);
      expect(agentCard.description, 'Just a hello world agent');
      expect(agentCard.name, 'Hello World Agent');
      expect(agentCard.version, '1.0.0');
      expect(agentCard.skills.isNotEmpty, isTrue);
      expect(agentCard.skills.first.description, 'just returns hello world');
      expect(agentCard.skills.first.examples, ['hi', 'hello world']);
      expect(agentCard.skills.first.id, 'hello_world');
      expect(agentCard.skills.first.name, 'Returns hello world');
      expect(agentCard.skills.first.tags, ['hello world']);
    });
    test('Get Service Endpoint', () async {
      if (testClient == null) {
        testClient = A2AClient(baseUrl);
        await Future.delayed(Duration(seconds: 1));
      }
      final endpoint = await testClient!.serviceEndpoint;
      expect(endpoint, 'http://localhost:9999/');
    });
  });
  return 0;
}
