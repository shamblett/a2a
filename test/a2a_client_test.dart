/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

@TestOn('vm')
library;

import 'dart:io';
import 'dart:convert';

import 'package:test/test.dart';
import 'package:shelf/shelf.dart';

import 'package:a2a/a2a.dart';

import 'support/a2a_test_client_server.dart';

Future<int> main() async {
  late A2AClient testClient;

  /// Start the client test server
  print('Client Test:: starting.....');
  final testClientServer = await A2ATestClientServer().start();

  /// Check it
  final ok = await Utilities.checkServer();
  if (!ok) {
    print('Client Test - Server is not available, exiting');
    exit(-1);
  }

  /// JSON encoder
  String jsonEncode(Object? data) => JsonEncoder.withIndent(' ').convert(data);

  group('Client', () {
    test('Construction', () async {
      final testCard = A2AAgentCard()
        ..description = 'The Description'
        ..name = 'The Name'
        ..url = 'http://localhost:8081'
        ..version = '1.0';
      final testCardJson = testCard.toJson();
      Response handler(Request request) => Response(
        200,
        headers: {
          'content-type': 'application/json',
          'Cache-Control': 'no-store',
        },
        body: jsonEncode(testCardJson),
      );
      const baseUrl = 'http://localhost:8080/';
      testClientServer.router.get('/.well-known/agent.json', handler);
      testClient = A2AClient(baseUrl);
      await Future.delayed(Duration(seconds: 1));
      expect(testClient.agentBaseUrl, 'http://localhost:8080');
      expect(await testClient.serviceEndpoint, 'http://localhost:8081');
    });
  });

  group('Agent', () {
    test('Get Agent Card', () async {
      final agentCard = await testClient.getAgentCard();
      expect(testClient.agentBaseUrl, 'http://localhost:8080');
      expect(await testClient.serviceEndpoint, 'http://localhost:8081');
      expect(agentCard.agentProvider, isNull);
      expect(agentCard.description, 'The Description');
      expect(agentCard.name, 'The Name');
      expect(agentCard.version, '1.0');
    });
    test('Get Service Endpoint', () async {
      final endpoint = await testClient.serviceEndpoint;
      expect(endpoint, 'http://localhost:8081');
    });
  });

  return 0;
}
