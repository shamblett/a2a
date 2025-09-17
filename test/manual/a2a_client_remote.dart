/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

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
  A2AClient? testClient;
  const baseUrl = 'https://sample-a2a-agent-908687846511.us-central1.run.app';

  group('Client Base', () {
    test('Construction', () async {
      testClient = A2AClient(baseUrl);
      expect(
        testClient!.agentBaseUrl,
        'https://sample-a2a-agent-908687846511.us-central1.run.app',
      );
      expect(
        await testClient!.serviceEndpoint,
        'https://sample-a2a-agent-908687846511.us-central1.run.app/',
      );
    });
    test('Get Agent Card', () async {
      testClient ??= A2AClient(baseUrl);
      final agentCard = await testClient!.getAgentCard(
        agentBaseUrl:
            'https://sample-a2a-agent-908687846511.us-central1.run.app',
      );
      expect(
        testClient!.agentBaseUrl,
        'https://sample-a2a-agent-908687846511.us-central1.run.app',
      );
      expect(
        await testClient!.serviceEndpoint,
        'https://sample-a2a-agent-908687846511.us-central1.run.app/',
      );
      expect(agentCard.capabilities.streaming, isTrue);
      expect(agentCard.defaultInputModes, ['text', 'text/plain']);
      expect(agentCard.defaultOutputModes, ['text', 'text/plain']);
      expect(agentCard.description, 'Agent to give interesting facts.');
      expect(agentCard.name, 'facts_agent');
      expect(agentCard.version, '1.0.0');
      expect(agentCard.skills.isNotEmpty, isTrue);
      expect(
        agentCard.skills.first.description,
        'Searches Google for interesting facts',
      );
      expect(agentCard.skills.first.examples, [
        'Provide an interesting fact about New York City.',
      ]);
      expect(agentCard.skills.first.id, 'give_facts');
      expect(agentCard.skills.first.name, 'Provide Interesting Facts');
      expect(agentCard.skills.first.tags, ['search', 'google', 'facts']);
    });
    test('Get Service Endpoint', () async {
      testClient ??= A2AClient(baseUrl);
      final endpoint = await testClient!.serviceEndpoint;
      expect(
        endpoint,
        'https://sample-a2a-agent-908687846511.us-central1.run.app/',
      );
    });
  });
  group('Client Methods', () {
    test('Send Message', () async {
      testClient ??= A2AClient(baseUrl);
      final message = A2AMessage()
        ..role = 'user'
        ..parts = [A2ATextPart()..text = 'prompt']
        ..messageId = '12345'
        ..taskId = '123'
        ..contextId = '456';

      final configuration = A2AMessageSendConfiguration()
        ..acceptedOutputModes = ['text'];

      final payload = A2AMessageSendParams()
        ..message = message
        ..configuration = configuration;

      try {
        final rpcResponse = await testClient!.sendMessage(payload);
        expect(rpcResponse.isError, isFalse);
        final response = rpcResponse as A2ASendMessageSuccessResponse;
        expect(response.id, 1);
        expect(response.result, isNotNull);
        expect(response.result is A2ATask, isTrue);
        final result = response.result as A2ATask;
        expect(result.artifacts, isNotNull);
        expect(result.contextId, '456');
        expect(result.id, '123');
        expect(result.metadata, isNull);
        expect(result.status, isNotNull);
        expect(result.status?.message, isNull);
        expect(result.status?.state, A2ATaskState.completed);
      } catch (e) {
        rethrow;
      }
    });
    test('Send Message Stream', () async {
      testClient ??= A2AClient(baseUrl);
      final message = A2AMessage()
        ..role = 'user'
        ..parts = [A2ATextPart()..text = 'prompt']
        ..messageId = '12345'
        ..taskId = '123'
        ..contextId = '456';

      final configuration = A2AMessageSendConfiguration()
        ..acceptedOutputModes = ['text'];

      final payload = A2AMessageSendParams()
        ..message = message
        ..configuration = configuration;

      try {
        final rpcResponse = await testClient!.sendMessageStream(payload).first;
        expect(rpcResponse.isError, isFalse);
        final response = rpcResponse as A2ASendStreamMessageSuccessResponse;
        expect(response.result, isNotNull);
        expect(response.result is A2ATask, isTrue);
        final result = response.result as A2ATask;
        expect(result.artifacts, isNotNull);
        expect(result.contextId, '456');
        expect(result.id, '123');
        expect(result.metadata, isNull);
        expect(result.status, isNotNull);
        expect(result.status?.message, isNull);
        expect(result.status?.state, A2ATaskState.completed);
      } catch (e) {
        rethrow;
      }
    });
    test('Set Task Push NotificationConfig', () async {
      testClient ??= A2AClient(baseUrl);
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
      testClient ??= A2AClient(baseUrl);
      final taskParams = A2AGetTaskPushNotificationConfigParams()..id = '1';

      try {
        final response = await testClient!.getTaskPushNotificationConfig(
          taskParams,
        );
        expect(response.isError, isTrue);
        final errorResponse = response as A2AJSONRPCErrorResponseGTPR;
        expect(
          errorResponse.error?.rpcErrorCode,
          A2AError.unsupportedOperation,
        );
        expect(
          (errorResponse as dynamic).error?.code,
          A2AError.unsupportedOperation,
        );
        expect(
          (errorResponse as dynamic).error.message,
          'This operation is not supported',
        );
      } catch (e) {
        rethrow;
      }
    });
    test('Get Task', () async {
      testClient ??= A2AClient(baseUrl);
      final taskParams = A2ATaskQueryParams()..id = '1';

      try {
        final response = await testClient!.getTask(taskParams);
        expect(response.isError, isTrue);
        final errorResponse = response as A2AJSONRPCErrorResponseT;
        expect(errorResponse.error?.rpcErrorCode, A2AError.taskNotFound);
        expect((errorResponse as dynamic).error?.code, A2AError.taskNotFound);
        expect((errorResponse as dynamic).error.message, 'Task not found');
      } catch (e) {
        rethrow;
      }
    });
    test('Cancel Task', () async {
      testClient ??= A2AClient(baseUrl);
      final taskParams = A2ATaskIdParams()..id = '1';

      try {
        final response = await testClient!.cancelTask(taskParams);
        expect(response.isError, isTrue);
        final errorResponse = response as A2AJSONRPCErrorResponse;
        expect(errorResponse.error?.rpcErrorCode, A2AError.taskNotFound);
        expect((errorResponse as dynamic).error?.code, A2AError.taskNotFound);
        expect((errorResponse as dynamic).error.message, 'Task not found');
      } catch (e) {
        rethrow;
      }
    });
    test('Resubscribe Task', () async {
      testClient ??= A2AClient(baseUrl);
      final taskParams = A2ATaskIdParams()..id = '1';

      try {
        final response = await testClient!.resubscribeTask(taskParams).first;
        expect(response.isError, isTrue);
        final errorResponse = response as A2AJSONRPCErrorResponseSSM;
        expect(errorResponse.error?.rpcErrorCode, A2AError.taskNotFound);
        expect((errorResponse as dynamic).error?.code, A2AError.taskNotFound);
        expect((errorResponse as dynamic).error.message, 'Task not found');
      } catch (e) {
        rethrow;
      }
    });
  });
  return 0;
}
