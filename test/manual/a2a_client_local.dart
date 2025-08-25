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
/// http://localhost:9999. Either the local agent example or the podman
/// Python example.
///
/// Please start this before running this test otherwise the test will exit
/// with an error message.
///
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
  group('Client Methods', () {
    test('Send Message', () async {
      if (testClient == null) {
        testClient ??= A2AClient(baseUrl);
        await Future.delayed(Duration(seconds: 1));
      }
      final part = A2ATextPart()
        ..text = 'how much is 10 USD in INR?'
        ..kind = 'text';

      final message = A2AMessage()
        ..messageId = '12345'
        ..role = 'user'
        ..parts = [part];

      final payload = A2AMessageSendParams()..message = message;

      try {
        final rpcResponse = await testClient!.sendMessage(payload);
        expect(rpcResponse.isError, isFalse);
        final response = rpcResponse as A2ASendMessageSuccessResponse;
        expect(response.result, isNotNull);
        expect(response.result is A2AMessage, isTrue);
        final result = response.result as A2AMessage;
        expect(result.role, 'agent');
        expect(result.parts?.isNotEmpty, isTrue);
        final tPartList = result.parts as List<A2APart>;
        final tPart = tPartList.first as A2ATextPart;
        expect(tPart.text, 'Hello World');
      } catch (e) {
        rethrow;
      }
    });
    test('Send Message Stream', () async {
      if (testClient == null) {
        testClient ??= A2AClient(baseUrl);
        await Future.delayed(Duration(seconds: 1));
      }
      final message = A2AMessage()
        ..role = 'user'
        ..parts = [A2ATextPart()..text = 'prompt']
        ..messageId = '12345';

      final configuration = A2AMessageSendConfiguration()
        ..acceptedOutputModes = ['text'];

      final payload = A2AMessageSendParams()
        ..message = message
        ..configuration = configuration;

      try {
        await for (final rpcResponse in testClient!.sendMessageStream(
          payload,
        )) {
          expect(rpcResponse.isError, isFalse);
          final response = rpcResponse as A2ASendStreamMessageSuccessResponse;
          expect(response.result, isNotNull);
          if (response.result is A2ATask) {
            continue;
          }
          if (response.result is A2AMessage) {
            final result = response.result as A2AMessage;
            expect(result.role, 'agent');
            expect(result.parts?.isNotEmpty, isTrue);
            final tPartList = result.parts as List<A2APart>;
            final tPart = tPartList.first as A2ATextPart;
            expect(tPart.text, 'Hello World');
          }
        }
      } catch (e) {
        rethrow;
      }
    });
    test('Set Task Push NotificationConfig', () async {
      if (testClient == null) {
        testClient ??= A2AClient(baseUrl);
        await Future.delayed(Duration(seconds: 1));
      }
      final taskConfig = A2APushNotificationConfig()
        ..id = '2'
        ..token = 'token'
        ..url = 'http://localhost:5000';

      final config = A2ATaskPushNotificationConfig()
        ..taskId = '1'
        ..pushNotificationConfig = taskConfig;

      try {
        await testClient!.setTaskPushNotificationConfig(config);
      } on Exception catch (e) {
        expect(
          e.toString(),
          'Exception: setTaskPushNotificationConfig:: Agent does not support push notifications(AgentCard.capabilities.pushnotifications is null).',
        );
      }
    });
    test('Get Task Push Notification Config', () async {
      if (testClient == null) {
        testClient ??= A2AClient(baseUrl);
        await Future.delayed(Duration(seconds: 1));
      }

      final config = A2AGetTaskPushNotificationConfigParams()
        ..id = '1'
        ..pushNotificationConfigId = '10';

      try {
        await testClient!.getTaskPushNotificationConfig(config);
      } on Exception catch (e) {
        expect(
          e.toString(),
          'Exception: getTaskPushNotificationConfig:: Agent does not support push notifications(AgentCard.capabilities.pushnotifications is null).',
        );
      }
    });
    test('Get Task', () async {
      if (testClient == null) {
        testClient ??= A2AClient(baseUrl);
        await Future.delayed(Duration(seconds: 1));
      }
      final taskParams = A2ATaskQueryParams()..id = '1';

      try {
        final response = await testClient!.getTask(taskParams);
        expect(response.isError, isTrue);
        final errorResponse = response as A2AJSONRPCErrorResponseT;
        expect(errorResponse.error?.rpcErrorCode, A2AError.taskNotFound);
        expect((errorResponse as dynamic).error?.code, A2AError.taskNotFound);
        expect(
          (errorResponse as dynamic).error.message.contains('Task not found'),
          isTrue,
        );
      } catch (e) {
        rethrow;
      }
    });
    test('Cancel Task', () async {
      if (testClient == null) {
        testClient ??= A2AClient(baseUrl);
        await Future.delayed(Duration(seconds: 1));
      }
      final taskParams = A2ATaskIdParams()..id = '1';

      try {
        final response = await testClient!.cancelTask(taskParams);
        expect(response.isError, isTrue);
        final errorResponse = response as A2AJSONRPCErrorResponse;
        expect(errorResponse.error?.rpcErrorCode, A2AError.taskNotFound);
        expect((errorResponse as dynamic).error?.code, A2AError.taskNotFound);
        expect(
          (errorResponse as dynamic).error.message.contains('Task not found'),
          isTrue,
        );
      } catch (e) {
        rethrow;
      }
    });
    test('Resubscribe Task', () async {
      if (testClient == null) {
        testClient ??= A2AClient(baseUrl);
        await Future.delayed(Duration(seconds: 1));
      }
      final taskParams = A2ATaskIdParams()..id = '1';

      try {
        final response = await testClient!.resubscribeTask(taskParams).first;
        expect(response.isError, isTrue);
        final errorResponse = response as A2AJSONRPCErrorResponseSSM;
        expect(errorResponse.error?.rpcErrorCode, A2AError.taskNotFound);
        expect((errorResponse as dynamic).error?.code, A2AError.taskNotFound);
        expect(
          (errorResponse as dynamic).error.message.contains('Task not found'),
          isTrue,
        );
      } catch (e) {
        rethrow;
      }
    });
  });
  return 0;
}
