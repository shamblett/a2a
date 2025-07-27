/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

@TestOn('vm')
library;

import 'dart:convert';

import 'package:test/test.dart';

import 'package:a2a/a2a.dart';

Future<int> main() async {
  late A2AClient testClient;
  // JSON encoder
  String jsonEncode(Object? data) => JsonEncoder.withIndent(' ').convert(data);

  group('Client', () {
    test('Construction', () async {
      const baseUrl = 'https://sample-a2a-agent-908687846511.us-central1.run.app';
      testClient = A2AClient(baseUrl);
      await Future.delayed(Duration(seconds: 1));
      expect(testClient.agentBaseUrl, 'https://sample-a2a-agent-908687846511.us-central1.run.app');
      expect(await testClient.serviceEndpoint, 'http://localhost:8080');
    });
  });

  group('Agent', () {
    test('Get Agent Card', () async {
      final dynamic agentCard = {}; // TODO
      expect(testClient.agentBaseUrl, 'http://localhost:8080');
      expect(await testClient.serviceEndpoint, 'http://localhost:8080');
      expect(agentCard.agentProvider, isNull);
      expect(agentCard.description, 'The Description');
      expect(agentCard.name, 'The Name');
      expect(agentCard.version, '1.0');
    });
    test('Get Service Endpoint', () async {
      final endpoint = await testClient.serviceEndpoint;
      expect(endpoint, 'http://localhost:8080');
    });
  });

  group('Client RPC', () {
    test('Send Message', () async {
      try {
        final params = A2AMessageSendParams()..metadata = {'First': 1};
        final response = await testClient.sendMessage(params);
        expect(response.isError, isFalse);
      } catch (e) {
        rethrow;
      }
    });
  });
  return 0;
}
