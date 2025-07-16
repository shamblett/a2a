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

import 'support/a2a_test_server.dart';

Future<int> main() async {
  /// Start the test server
  print('Client Test:: starting.....');
  final testServer = await A2ATestServer().start();
  late A2AClient testAgent;

  /// Check it
  final ok = await Utilities.checkServer();
  if (!ok) {
    print('Client Test - Server is not available, exiting');
    exit(-1);
  }

  /// JSON encoder
  String jsonEncode(Object? data) => JsonEncoder.withIndent(' ').convert(data);

  /// Tests
  test('Construction', () async {
    Response handler(Request request) => Response(
      200,
      headers: {
        'content-type': 'application/json',
        'Cache-Control': 'no-store',
      },
      body: jsonEncode({
        'defaultModes': [],
        'defaultOutputModes': [],
        'description': 'The description',
        'documentation': 'The documentation',
        'iconUrl': 'http://iconUrl',
        'name': 'Test Agent',
        'skills': [],
        'url': 'http://url',
        'version': '1.0',
      }),
    );
    const baseUrl = 'http://localhost:8080/';
    testServer.router.get('/.well-known/agent.json', handler);
    testAgent = A2AClient(baseUrl);
    await Future.delayed(Duration(seconds: 1));
    expect(testAgent.agentBaseUrl, 'http://localhost:8080');
    expect(testAgent.serviceEndpointUrl, 'http://url');
  });

  group('Agent', () {
    test('Get Agent Card', () async {
      final agentCard = await testAgent.getAgentCard();
      expect(testAgent.agentBaseUrl, 'http://localhost:8080');
      expect(testAgent.serviceEndpointUrl, 'http://url');
      expect(agentCard.agentProvider, isNull);
      expect(agentCard.description, 'The description');
    });
  });
  return 0;
}
