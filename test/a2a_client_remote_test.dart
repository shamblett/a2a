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

/// Tests the client against the remote agent located at
/// https://sample-a2a-agent-908687846511.us-central1.run.app
/// See the README file in test/support/hosts/cli for more details.
///
/// This agent returns the following JSON for its Agent Card :-
///
/// '{"capabilities":{"streaming":true},"defaultInputModes":["text","text/plain"],
/// "defaultOutputModes":["text","text/plain"],"description":"Agent to give interesting facts.",
/// "name":"facts_agent","protocolVersion":"0.2.6","skills":[{"description":"Searches Google for interesting facts",
/// "examples":["Provide an interesting fact about New York City."],"id":"give_facts","
/// name":"Provide Interesting Facts","tags":["search","google","facts"]}],
/// "url":"https://sample-a2a-agent-908687846511.us-central1.run.app/","version":"1.0.0"}'

Future<int> main() async {
  late A2AClient testClient;

  group('Client', () {
    test('Construction', () async {
      const baseUrl =
          'https://sample-a2a-agent-908687846511.us-central1.run.app';
      testClient = A2AClient(baseUrl);
      await Future.delayed(Duration(seconds: 1));
      expect(
        testClient.agentBaseUrl,
        'https://sample-a2a-agent-908687846511.us-central1.run.app',
      );
      expect(
        await testClient.serviceEndpoint,
        'https://sample-a2a-agent-908687846511.us-central1.run.app/',
      );
    });
  });
  test('Get Agent Card', () async {
    const baseUrl = 'https://sample-a2a-agent-908687846511.us-central1.run.app';
    testClient = A2AClient(baseUrl);
    await Future.delayed(Duration(seconds: 1));
    final agentCard = await testClient.getAgentCard(
      agentBaseUrl: 'https://sample-a2a-agent-908687846511.us-central1.run.app',
    );
    expect(
      testClient.agentBaseUrl,
      'https://sample-a2a-agent-908687846511.us-central1.run.app',
    );
    expect(
      await testClient.serviceEndpoint,
      'https://sample-a2a-agent-908687846511.us-central1.run.app/',
    );
    expect(agentCard.capabilities.streaming, isTrue);
    expect(agentCard.defaultInputModes, ['text', 'text/plain']);
    expect(agentCard.defaultOutputModes, ['text', 'text/plain']);
    expect(agentCard.description, 'Agent to give interesting facts.');
    expect(agentCard.name, 'facts_agent');
    expect(agentCard.version, '1.0.0');
    expect(agentCard.skills.isNotEmpty, isTrue);
  });
  test('Get Service Endpoint', () async {
    final endpoint = await testClient.serviceEndpoint;
    expect(endpoint, 'http://localhost:8080');
  });
  test('Send Message', () async {
    try {
      final params = A2AMessageSendParams()..metadata = {'First': 1};
      final response = await testClient.sendMessage(params);
      expect(response.isError, isFalse);
    } catch (e) {
      rethrow;
    }
  });
  return 0;
}
