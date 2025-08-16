/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

@TestOn('vm')
library;

import 'dart:async';

import 'package:test/test.dart';

import 'package:a2a/src/server/a2a_server.dart';

import 'support/a2a_test_agent_executor.dart';

void main() {
  group('Utilities', () {
    test('getCurrentTimestamp', () {
      final dt = A2AUtilities.getCurrentTimestamp();
      expect(dt.length, 'yyyy-MM-ddTHH:mm:ss.mmm'.length);
    });
    test('isTaskStatusUpdate', () {
      expect(A2AUtilities.isTaskStatusUpdate(A2ATaskStatus()), isTrue);
      expect(A2AUtilities.isTaskStatusUpdate(A2ATask()), isFalse);
    });
    test('isTaskArtifactUpdate', () {
      expect(A2AUtilities.isTaskArtifactUpdate(A2AArtifact()), isTrue);
      expect(A2AUtilities.isTaskArtifactUpdate(A2AMessage()), isFalse);
    });
  });

  group('Store', () {
    test('In Memory Task Store', () async {
      final store = A2AInMemoryTaskStore();
      A2ATask task = A2ATask()
        ..id = 'Task Id'
        ..status = A2ATaskStatus()
        ..metadata = {'First': 1};
      await store.save(task);
      expect(store.count, 1);
      task.metadata = {'Second': 2};
      task.id = 'New Task Id';
      final retTask = await store.load('Task Id');
      expect(retTask, isNotNull);
      expect(retTask?.metadata?['First'], 1);
      expect(retTask?.id, 'Task Id');
      final nullTask = await store.load('Test');
      expect(nullTask, isNull);
    });
  });
  group('Error', () {
    test('Construction', () {
      final error = A2AServerError(A2AError.internal, 'Unknown Error', {
        'd1': 1,
      }, '10');
      final jsonError = error.toJSONRPCError();
      expect(jsonError.message, 'Unknown Error');
      expect(jsonError.code, A2AError.internal);
      expect(jsonError.data, {'d1': 1});
      dynamic testError = A2AServerError.parseError('The message', {'d1': 1});
      expect(testError is A2AJSONParseError, isTrue);
      expect(testError.message, 'The message');
      expect(testError.data, {'d1': 1});
      testError = A2AServerError.invalidRequest('The message', {'d1': 1});
      expect(testError is A2AInvalidRequestError, isTrue);
      expect(testError.message, 'The message');
      expect(testError.data, {'d1': 1});
      testError = A2AServerError.invalidParams('The message', {'d1': 1});
      expect(testError is A2AInvalidParamsError, isTrue);
      expect(testError.message, 'The message');
      expect(testError.data, {'d1': 1});
      testError = A2AServerError.internalError('The message', {'d1': 1});
      expect(testError is A2AInternalError, isTrue);
      expect(testError.message, 'The message');
      expect(testError.data, {'d1': 1});
      testError = A2AServerError.methodNotFound('post');
      expect(testError is A2AMethodNotFoundError, isTrue);
      expect(testError.message, 'Method not found: post');
      testError = A2AServerError.taskNotFound('10');
      expect(testError is A2ATaskNotFoundError, isTrue);
      expect(testError.message, 'Task not found: 10');
      expect(testError.data, {'taskId': '10'});
      testError = A2AServerError.taskNotCancelable('10');
      expect(testError is A2ATaskNotCancelableError, isTrue);
      expect(testError.message, 'Task not cancelable: 10');
      expect(testError.data, {'taskId': '10'});
      testError = A2AServerError.pushNotificationNotSupported();
      expect(testError is A2APushNotificationNotSupportedError, isTrue);
      expect(testError.message, 'Push Notification is not supported');
      testError = A2AServerError.unsupportedOperation('operation');
      expect(testError is A2AUnsupportedOperationError, isTrue);
      expect(testError.message, 'Unsupported operation: operation');
    });
  });
  group('Result Manager', () {
    test('Construction', () {
      final store = A2AInMemoryTaskStore();
      final rm = A2AResultManager(store);
      expect(rm.finalResult is A2ATask?, isTrue);
      expect(rm.finalResult, isNull);
      expect(rm.currentTask, isNull);
    });
    test('Process Event - Message Update', () {
      final store = A2AInMemoryTaskStore();
      final rm = A2AResultManager(store);
      final message = A2AMessage();
      rm.processEvent(message);
      expect(rm.finalResult is A2AMessage?, isTrue);
      expect(rm.finalResult, isNotNull);
    });
    group('Process Event - Task Update', () {
      test('First No Context', () async {
        final store = A2AInMemoryTaskStore();
        final rm = A2AResultManager(store);
        final task = A2ATask()..id = '10';
        unawaited(rm.processEvent(task));
        expect(store.count, 1);
        final storeTask = await store.load('10');
        expect(storeTask?.id, '10');
        expect(rm.currentTask?.id, '10');
        task.id = '11';
        expect(rm.currentTask?.id, '10');
        expect(rm.currentTask?.history, []);
      });
      test('First With Context', () async {
        final store = A2AInMemoryTaskStore();
        final rm = A2AResultManager(store);
        final task = A2ATask()..id = '10';
        final message = A2AMessage()
          ..taskId = '10'
          ..messageId = '100';
        rm.context = message;
        unawaited(rm.processEvent(task));
        expect(store.count, 1);
        final storeTask = await store.load('10');
        expect(storeTask?.id, '10');
        expect(rm.currentTask?.id, '10');
        expect(rm.currentTask?.history?.length, 1);
        expect(rm.currentTask?.history?.first.messageId, '100');
      });
      test('Subsequent With Context', () async {
        final store = A2AInMemoryTaskStore();
        final rm = A2AResultManager(store);
        final task = A2ATask()..id = '10';
        final message = A2AMessage()
          ..taskId = '10'
          ..messageId = '100';
        rm.context = message;
        unawaited(rm.processEvent(task));
        expect(store.count, 1);
        expect(rm.currentTask?.id, '10');
        expect(rm.currentTask?.history?.length, 1);
        expect(rm.currentTask?.history?.first.messageId, '100');
        unawaited(rm.processEvent(task));
        expect(store.count, 1);
        expect(rm.currentTask?.id, '10');
        expect(rm.currentTask?.history?.length, 1);
        expect(rm.currentTask?.history?.first.messageId, '100');
      });
    });
    group('Process Event - Task Status Update', () {
      test('First No Status', () async {
        final store = A2AInMemoryTaskStore();
        final rm = A2AResultManager(store);
        final taskStatusUpdate = A2ATaskStatusUpdateEvent()..taskId = '10';
        unawaited(rm.processEvent(taskStatusUpdate));
        expect(store.count, 0);
      });
      test('First No Current task', () async {
        final store = A2AInMemoryTaskStore();
        final rm = A2AResultManager(store);
        final taskStatusUpdate = A2ATaskStatusUpdateEvent()
          ..taskId = '10'
          ..status = (A2ATaskStatus()..state = A2ATaskState.completed);
        unawaited(rm.processEvent(taskStatusUpdate));
        expect(store.count, 0);
      });
      test('First With Current task', () async {
        final store = A2AInMemoryTaskStore();
        final rm = A2AResultManager(store);
        final taskStatusUpdate = A2ATaskStatusUpdateEvent()
          ..taskId = '10'
          ..status = (A2ATaskStatus()..state = A2ATaskState.completed);
        final task = A2ATask()..id = '10';
        unawaited(rm.processEvent(task));
        expect(store.count, 1);
        expect(rm.currentTask?.id, '10');
        unawaited(rm.processEvent(taskStatusUpdate));
        expect(rm.currentTask?.status?.state, A2ATaskState.completed);
        expect(rm.currentTask?.history, []);
        expect(store.count, 1);
        final taskStatusUpdateMessage = A2ATaskStatusUpdateEvent()
          ..taskId = '10'
          ..status = (A2ATaskStatus()..state = A2ATaskState.authRequired)
          ..status?.message = (A2AMessage()..messageId = '100');
        unawaited(rm.processEvent(taskStatusUpdateMessage));
        expect(rm.currentTask?.status?.state, A2ATaskState.authRequired);
        expect(rm.currentTask?.history?.first.messageId, '100');
        expect(store.count, 1);
      });
      test('First With Current task - Wrong task id', () async {
        final store = A2AInMemoryTaskStore();
        final rm = A2AResultManager(store);
        final task = A2ATask()..id = '10';
        await store.save(task);
        final taskStatusUpdate = A2ATaskStatusUpdateEvent()
          ..taskId = '10'
          ..status = (A2ATaskStatus()..state = A2ATaskState.completed);
        await rm.processEvent(taskStatusUpdate);
        expect(store.count, 1);
        expect(rm.currentTask?.id, '10');
        expect(rm.currentTask?.history, []);
      });
      test('First With Current task - Wrong task id with message', () async {
        final store = A2AInMemoryTaskStore();
        final rm = A2AResultManager(store);
        final task = A2ATask()..id = '10';
        final message = A2AMessage()
          ..taskId = '10'
          ..messageId = '100';
        await store.save(task);
        final taskStatusUpdate = A2ATaskStatusUpdateEvent()
          ..taskId = '10'
          ..status = (A2ATaskStatus()
            ..state = A2ATaskState.completed
            ..message = message);
        await rm.processEvent(taskStatusUpdate);
        expect(store.count, 1);
        expect(rm.currentTask?.id, '10');
        expect(rm.currentTask?.history?.length, 1);
        expect(rm.currentTask?.history?.first.messageId, '100');
      });
    });
  });
  group('Process Event - Artifact Update', () {
    test('First No Artifact', () async {
      final store = A2AInMemoryTaskStore();
      final rm = A2AResultManager(store);
      final task = A2ATask()..id = '10';
      unawaited(rm.processEvent(task));
      final artifactUpdate = A2ATaskArtifactUpdateEvent()..taskId = '10';
      unawaited(rm.processEvent(artifactUpdate));
      expect(store.count, 1);
    });
    test('First Unknown task', () async {
      final store = A2AInMemoryTaskStore();
      final rm = A2AResultManager(store);
      final task = A2ATask()..id = '11';
      unawaited(rm.processEvent(task));
      final artifact = A2AArtifact()..artifactId = '300';
      final artifactUpdate = A2ATaskArtifactUpdateEvent()
        ..taskId = '12'
        ..artifact = artifact;
      unawaited(rm.processEvent(artifactUpdate));
      expect(store.count, 1);
    });
    test('First No Current task', () async {
      final store = A2AInMemoryTaskStore();
      final rm = A2AResultManager(store);
      final artifactUpdate = A2ATaskArtifactUpdateEvent()..taskId = '10';
      unawaited(rm.processEvent(artifactUpdate));
      expect(store.count, 0);
    });
    test('First with current task', () async {
      final store = A2AInMemoryTaskStore();
      final rm = A2AResultManager(store);
      final artifact = A2AArtifact()..artifactId = '200';
      final task = A2ATask()..id = '10';
      final artifactUpdate = A2ATaskArtifactUpdateEvent()
        ..taskId = '10'
        ..artifact = artifact;
      unawaited(rm.processEvent(task));
      expect(store.count, 1);
      expect(rm.currentTask?.id, '10');
      unawaited(rm.processEvent(artifactUpdate));
      expect(rm.currentTask?.artifacts?.first.artifactId, '200');
      expect(rm.currentTask?.artifacts?.first.description, isNull);
      artifact.description = 'The description';
      unawaited(rm.processEvent(artifactUpdate));
      expect(store.count, 1);
      expect(rm.currentTask?.artifacts?.first.description, 'The description');
    });
    test('Subsequent current task with append', () async {
      final store = A2AInMemoryTaskStore();
      final rm = A2AResultManager(store);
      final artifact = A2AArtifact()..artifactId = '200';
      final task = A2ATask()..id = '10';
      final artifactUpdate = A2ATaskArtifactUpdateEvent()
        ..taskId = '10'
        ..artifact = artifact;
      unawaited(rm.processEvent(task));
      expect(store.count, 1);
      expect(rm.currentTask?.id, '10');
      unawaited(rm.processEvent(artifactUpdate));
      expect(rm.currentTask?.artifacts?.first.artifactId, '200');
      expect(rm.currentTask?.artifacts?.first.description, isNull);
      artifact.description = 'The description';
      unawaited(rm.processEvent(artifactUpdate));
      expect(store.count, 1);
      expect(rm.currentTask?.artifacts?.first.description, 'The description');
      artifactUpdate.append = true;
      artifact.description = 'The new description';
      artifact.name = 'Artifact name';
      artifact.metadata = {'First': 1};
      artifact.parts = [];
      artifact.parts.add(A2ATextPart()..text = 'Part Text');
      unawaited(rm.processEvent(artifactUpdate));
      expect(store.count, 1);
      expect(
        rm.currentTask?.artifacts?.first.description,
        'The new description',
      );
      expect(rm.currentTask?.artifacts?.first.name, 'Artifact name');
      expect(rm.currentTask?.artifacts?.first.metadata, {'First': 1});
      final textPart =
          rm.currentTask?.artifacts?.first.parts.first as A2ATextPart;
      expect(textPart.text, 'Part Text');
    });
    test('First no current task', () async {
      final store = A2AInMemoryTaskStore();
      final rm = A2AResultManager(store);
      final artifact = A2AArtifact()..artifactId = '200';
      final artifactUpdate = A2ATaskArtifactUpdateEvent()
        ..taskId = '10'
        ..artifact = artifact;
      final task = A2ATask()..id = '10';
      await store.save(task);
      expect(store.count, 1);
      expect(rm.currentTask?.id, isNull);
      await rm.processEvent(artifactUpdate);
      expect(rm.currentTask?.artifacts?.first.artifactId, '200');
      expect(rm.currentTask?.artifacts?.first.description, isNull);
      artifact.description = 'The description';
      await rm.processEvent(artifactUpdate);
      expect(store.count, 1);
      artifact.description = 'The description';
    });
    test('Subsequent no current task with append', () async {
      final store = A2AInMemoryTaskStore();
      final rm = A2AResultManager(store);
      final artifact = A2AArtifact()..artifactId = '200';
      final artifactUpdate = A2ATaskArtifactUpdateEvent()
        ..taskId = '10'
        ..artifact = artifact;
      final task = A2ATask()
        ..id = '10'
        ..artifacts = [];
      task.artifacts?.add(artifact);
      await store.save(task);
      expect(store.count, 1);
      expect(rm.currentTask?.id, isNull);
      artifactUpdate.append = true;
      artifact.description = 'The new description';
      artifact.name = 'The new Artifact name';
      artifact.metadata = {'Second': 2};
      artifact.parts = [];
      artifact.parts.add(A2ATextPart()..text = 'New Part Text');
      await rm.processEvent(artifactUpdate);
      expect(store.count, 1);
      expect(
        rm.currentTask?.artifacts?.first.description,
        'The new description',
      );
      expect(rm.currentTask?.artifacts?.first.name, 'The new Artifact name');
      expect(rm.currentTask?.artifacts?.first.metadata, {'Second': 2});
      final textPart =
          rm.currentTask?.artifacts?.first.parts.first as A2ATextPart;
      expect(textPart.text, 'New Part Text');
    });
    test('Subsequent no current task no append', () async {
      final store = A2AInMemoryTaskStore();
      final rm = A2AResultManager(store);
      final artifact = A2AArtifact()..artifactId = '200';
      final artifactUpdate = A2ATaskArtifactUpdateEvent()
        ..taskId = '10'
        ..artifact = artifact;
      final task = A2ATask()
        ..id = '10'
        ..artifacts = [];
      task.artifacts?.add(artifact);
      await store.save(task);
      expect(store.count, 1);
      expect(rm.currentTask?.id, isNull);
      artifact.description = 'The new description';
      artifact.name = 'The new Artifact name';
      artifact.metadata = {'Second': 2};
      artifact.parts = [];
      artifact.parts.add(A2ATextPart()..text = 'New Part Text');
      await rm.processEvent(artifactUpdate);
      expect(store.count, 1);
      expect(
        rm.currentTask?.artifacts?.first.description,
        'The new description',
      );
      expect(rm.currentTask?.artifacts?.first.name, 'The new Artifact name');
      expect(rm.currentTask?.artifacts?.first.metadata, {'Second': 2});
      final textPart =
          rm.currentTask?.artifacts?.first.parts.first as A2ATextPart;
      expect(textPart.text, 'New Part Text');
    });
  });
  group('Events', () {
    test('Default Execution Event Bus', () {
      bool eventHandlerCalled = false;
      bool finishHandlerCalled = false;
      void eventHandler(A2ATaskStatusUpdateEvent data) {
        expect(data.taskId, '10');
        eventHandlerCalled = true;
      }

      void finishHandler(_) {
        finishHandlerCalled = true;
      }

      final deh = A2ADefaultExecutionEventBus();
      final event = A2ATaskStatusUpdateEvent()..taskId = '10';
      deh.on(A2AExecutionEventBus.a2aEBEvent, eventHandler);
      deh.on(A2AExecutionEventBus.a2aEBFinished, finishHandler);
      deh.publish(event);
      expect(eventHandlerCalled, isTrue);
      deh.finished();
      expect(finishHandlerCalled, isTrue);
      eventHandlerCalled = false;
      finishHandlerCalled = false;
      deh.removeAllListeners(A2AExecutionEventBus.a2aEBEvent);
      deh.publish(event);
      expect(eventHandlerCalled, isFalse);
      deh.finished();
      expect(finishHandlerCalled, isFalse);
    });
    test('DefaultExecution Event Bus Manager', () {
      final deHm = A2ADefaultExecutionEventBusManager();
      expect(deHm.getByTaskId('10'), isNull);
      deHm.createOrGetByTaskId('10');
      deHm.createOrGetByTaskId('11');
      expect(deHm.getByTaskId('10'), isNotNull);
      expect(deHm.getByTaskId('11'), isNotNull);
      deHm.cleanupByTaskId('11');
      expect(deHm.getByTaskId('10'), isNotNull);
      expect(deHm.getByTaskId('11'), isNull);
    });
    test('Execution Event Queue Finish', () async {
      final deh = A2ADefaultExecutionEventBus();
      final eq = A2AExecutionEventQueue(deh);
      final task = A2ATask()..id = '100';
      final taskUpdate = A2ATaskStatusUpdateEvent()..taskId = '100';
      final artifactUpdate = A2ATaskArtifactUpdateEvent()..taskId = '100';
      deh.publish(task);
      deh.publish(taskUpdate);
      deh.publish(artifactUpdate);
      expect(eq.count, 3);
      final events = eq.events();
      await for (final event in events) {
        if (event is A2ATask) {
          expect(event.id, '100');
        }
        if (event is A2ATaskArtifactUpdateEvent) {
          expect(event.taskId, '100');
        }
        if (event is A2ATaskStatusUpdateEvent) {
          expect(event.taskId, '100');
        }
        if (eq.count == 0) {
          deh.finished();
        }
      }
      expect(eq.count, 0);
    });
    test('Execution Event Queue Message Ends', () async {
      final deh = A2ADefaultExecutionEventBus();
      final eq = A2AExecutionEventQueue(deh);
      final message = A2AMessage()..messageId = '10';
      final task = A2ATask()..id = '100';
      final taskUpdate = A2ATaskStatusUpdateEvent()..taskId = '100';
      final artifactUpdate = A2ATaskArtifactUpdateEvent()..taskId = '100';
      deh.publish(task);
      deh.publish(taskUpdate);
      deh.publish(artifactUpdate);
      expect(eq.count, 3);
      final events = eq.events();
      await for (final event in events) {
        if (event is A2ATask) {
          expect(event.id, '100');
        }
        if (event is A2ATaskArtifactUpdateEvent) {
          expect(event.taskId, '100');
        }
        if (event is A2ATaskStatusUpdateEvent) {
          expect(event.taskId, '100');
        }
        if (eq.count == 0) {
          deh.publish(message);
        }
      }
      expect(eq.count, 0);
    });
    test('Execution Event Queue Task Status Ends', () async {
      final deh = A2ADefaultExecutionEventBus();
      final eq = A2AExecutionEventQueue(deh);
      final task = A2ATask()..id = '100';
      final taskUpdate = A2ATaskStatusUpdateEvent()..taskId = '100';
      final taskEndUpdate = A2ATaskStatusUpdateEvent()
        ..taskId = '100'
        ..end = true;
      final artifactUpdate = A2ATaskArtifactUpdateEvent()..taskId = '100';
      deh.publish(task);
      deh.publish(taskUpdate);
      deh.publish(artifactUpdate);
      expect(eq.count, 3);
      final events = eq.events();
      await for (final event in events) {
        if (event is A2ATask) {
          expect(event.id, '100');
        }
        if (event is A2ATaskArtifactUpdateEvent) {
          expect(event.taskId, '100');
        }
        if (event is A2ATaskStatusUpdateEvent) {
          expect(event.taskId, '100');
        }
        if (eq.count == 0) {
          deh.publish(taskEndUpdate);
        }
      }
      expect(eq.count, 0);
    });
    test('Execution Event Queue Stop', () async {
      final deh = A2ADefaultExecutionEventBus();
      final eq = A2AExecutionEventQueue(deh);
      final task = A2ATask()..id = '100';
      final taskUpdate = A2ATaskStatusUpdateEvent()..taskId = '100';
      final artifactUpdate = A2ATaskArtifactUpdateEvent()..taskId = '100';
      deh.publish(task);
      deh.publish(taskUpdate);
      deh.publish(artifactUpdate);
      expect(eq.count, 3);
      final events = eq.events();
      await for (final event in events) {
        if (event is A2ATask) {
          expect(event.id, '100');
        }
        if (event is A2ATaskArtifactUpdateEvent) {
          expect(event.taskId, '100');
        }
        if (event is A2ATaskStatusUpdateEvent) {
          expect(event.taskId, '100');
          eq.stop();
        }
      }
      expect(eq.count, 1);
    });
    test('Execution Event Queue All Consumed', () async {
      final deh = A2ADefaultExecutionEventBus();
      final eq = A2AExecutionEventQueue(deh);
      final task = A2ATask()..id = '100';
      final taskUpdate = A2ATaskStatusUpdateEvent()..taskId = '100';
      final artifactUpdate = A2ATaskArtifactUpdateEvent()..taskId = '100';
      deh.publish(task);
      deh.publish(taskUpdate);
      deh.publish(artifactUpdate);
      expect(eq.count, 3);
      final events = eq.events();
      await for (final event in events) {
        if (event is A2ATask) {
          expect(event.id, '100');
        }
        if (event is A2ATaskArtifactUpdateEvent) {
          expect(event.taskId, '100');
        }
        if (event is A2ATaskStatusUpdateEvent) {
          expect(event.taskId, '100');
        }
      }
      expect(eq.count, 0);
    });
  });

  group('Default Request Handler', () {
    test('Construction', () async {
      final agentCard = A2AAgentCard();
      final drq = A2ADefaultRequestHandler(
        agentCard,
        A2AInMemoryTaskStore(),
        A2ATestAgentExecutor(),
        A2ADefaultExecutionEventBusManager(),
      );
      expect(await drq.agentCard, agentCard);
    });
    test('Resubscribe', () async {
      final agentCard = A2AAgentCard()
        ..capabilities = (A2AAgentCapabilities()..streaming = false);
      final store = A2AInMemoryTaskStore();
      final drq = A2ADefaultRequestHandler(
        agentCard,
        store,
        A2ATestAgentExecutor(),
        A2ADefaultExecutionEventBusManager(),
      );
      final params = A2ATaskIdParams()..id = '1';
      final task = A2ATask()
        ..id = '1'
        ..status = A2ATaskStatus();
      await expectLater(
        drq.resubscribe(params).first,
        throwsA(isA<A2AUnsupportedOperationError>()),
      );
      agentCard.capabilities.streaming = true;
      await expectLater(
        drq.resubscribe(params).first,
        throwsA(isA<A2ATaskNotFoundError>()),
      );
      await store.save(task);
      expect((await drq.resubscribe(params).first as A2ATask).id, '1');
      task.status?.state = A2ATaskState.canceled;
      await store.save(task);
      int eventCount = 0;
      await for (final event in drq.resubscribe(params)) {
        expect((event as A2ATask).id, '1');
        eventCount++;
      }
      expect(eventCount, 1);
      task.status?.state = A2ATaskState.submitted;
      await store.save(task);
      await for (final event in drq.resubscribe(params)) {
        expect((event as A2ATask).id, '1');
        eventCount++;
      }
      expect(eventCount, 2);
    });
    test('Set Task Push Notification Config', () async {
      final agentCard = A2AAgentCard()
        ..capabilities = (A2AAgentCapabilities()..pushNotifications = false);
      final store = A2AInMemoryTaskStore();
      final drq = A2ADefaultRequestHandler(
        agentCard,
        store,
        A2ATestAgentExecutor(),
        A2ADefaultExecutionEventBusManager(),
      );
      final params = A2ATaskPushNotificationConfig();
      await expectLater(
        drq.setTaskPushNotificationConfig(params),
        throwsA(isA<A2APushNotificationNotSupportedError>()),
      );
      agentCard.capabilities.pushNotifications = true;
      await expectLater(
        drq.setTaskPushNotificationConfig(params),
        throwsA(isA<A2ATaskNotFoundError>()),
      );
    });
    test('Get Task Push Notification Config', () async {
      final agentCard = A2AAgentCard()
        ..capabilities = (A2AAgentCapabilities()..pushNotifications = false);
      final store = A2AInMemoryTaskStore();
      final drq = A2ADefaultRequestHandler(
        agentCard,
        store,
        A2ATestAgentExecutor(),
        A2ADefaultExecutionEventBusManager(),
      );
      final params = A2ATaskIdParams()..id = '1';
      final task = A2ATask()
        ..id = '1'
        ..status = A2ATaskStatus();
      final configParams = A2ATaskPushNotificationConfig()
        ..taskId = '1'
        ..pushNotificationConfig = A2ATaskPushNotificationConfig1();
      await expectLater(
        drq.getTaskPushNotificationConfig(params),
        throwsA(isA<A2APushNotificationNotSupportedError>()),
      );
      agentCard.capabilities.pushNotifications = true;
      await expectLater(
        drq.getTaskPushNotificationConfig(params),
        throwsA(isA<A2ATaskNotFoundError>()),
      );
      await store.save(task);
      await expectLater(
        drq.getTaskPushNotificationConfig(params),
        throwsA(isA<A2AInternalError>()),
      );
      final setConfig = await drq.setTaskPushNotificationConfig(configParams);
      final getConfig = await drq.getTaskPushNotificationConfig(params);
      expect(
        setConfig?.pushNotificationConfig == getConfig?.pushNotificationConfig,
        isTrue,
      );
    });
    test('Cancel Task - No event Bus', () async {
      final agentCard = A2AAgentCard();
      final store = A2AInMemoryTaskStore();
      final drq = A2ADefaultRequestHandler(
        agentCard,
        store,
        A2ATestAgentExecutor(),
        A2ADefaultExecutionEventBusManager(),
      );
      final params = A2ATaskQueryParams()..id = '1';
      final task = A2ATask()
        ..id = '1'
        ..status = A2ATaskStatus();
      await expectLater(
        drq.cancelTask(params),
        throwsA(isA<A2ATaskNotFoundError>()),
      );
      await store.save(task);
      await expectLater(
        drq.cancelTask(params),
        throwsA(isA<A2ATaskNotCancelableError>()),
      );
      task.status?.state = A2ATaskState.completed;
      await store.save(task);
      await expectLater(
        drq.cancelTask(params),
        throwsA(isA<A2ATaskNotCancelableError>()),
      );
      task.status?.state = A2ATaskState.submitted;
      task.contextId = '2';
      await store.save(task);
      final taskRet = await drq.cancelTask((params));
      expect(taskRet.status?.state, A2ATaskState.canceled);
      expect(taskRet.status?.message?.messageId, isNotNull);
      expect(taskRet.status?.message?.messageId.length, 36);
      expect(taskRet.status?.message?.parts?.length, 1);
      expect(
        (taskRet.status?.message?.parts?.first as A2ATextPart).text,
        'Task cancellation requested by user.',
      );
      expect(taskRet.status?.message?.contextId, isNotNull);
      expect(taskRet.status?.message?.contextId, '2');
      expect(taskRet.status?.timestamp, isNotNull);
      expect(taskRet.status?.timestamp?.length, 23);
      expect(taskRet.history, isNotNull);
      expect(taskRet.history?.length, 1);
      expect(taskRet.history?.first is A2AMessage, isTrue);
      expect(
        (taskRet.history?.first)?.messageId,
        taskRet.status?.message?.messageId,
      );
    });
    test('Cancel Task - Event Bus', () async {
      final agentCard = A2AAgentCard();
      final store = A2AInMemoryTaskStore();
      final eventBus = A2ADefaultExecutionEventBusManager();
      final drq = A2ADefaultRequestHandler(
        agentCard,
        store,
        A2ATestAgentExecutor(),
        eventBus,
      );
      final params = A2ATaskQueryParams()..id = '1';
      final task = A2ATask()
        ..id = '1'
        ..status = A2ATaskStatus();
      task.status?.state = A2ATaskState.submitted;
      task.contextId = '2';
      await store.save(task);
      eventBus.createOrGetByTaskId('1');
      final taskRet = await drq.cancelTask((params));
      expect(taskRet.status?.state, A2ATaskState.submitted);
      expect(taskRet.contextId, '2');
      expect(taskRet.id, '1');
    });
    test('Get Task', () async {
      final agentCard = A2AAgentCard();
      final store = A2AInMemoryTaskStore();
      final drq = A2ADefaultRequestHandler(
        agentCard,
        store,
        A2ATestAgentExecutor(),
        A2ADefaultExecutionEventBusManager(),
      );
      final params = A2ATaskQueryParams()..id = '1';
      final task = A2ATask()
        ..id = '1'
        ..status = A2ATaskStatus();
      final message1 = A2AMessage()
        ..messageId = '100'
        ..taskId = '1';
      final message2 = A2AMessage()
        ..messageId = '200'
        ..taskId = '2';
      await expectLater(
        drq.getTask(params),
        throwsA(isA<A2ATaskNotFoundError>()),
      );
      await store.save(task);
      var taskRet = await drq.getTask(params);
      expect(taskRet.history, isNotNull);
      expect(taskRet.history?.isEmpty, isTrue);
      taskRet.history?.addAll([message1, message2]);
      await store.save(taskRet);
      params.historyLength = 1;
      taskRet = await drq.getTask(params);
      expect(taskRet.history?.isEmpty, isFalse);
      expect(taskRet.history?.length, 1);
      expect((taskRet.history?.first as A2AMessage).messageId, '100');
    });
    test('Send Message Stream - Error in Executor', () async {
      final agentCard = A2AAgentCard();
      final store = A2AInMemoryTaskStore();
      final busManager = A2ADefaultExecutionEventBusManager();
      final drq = A2ADefaultRequestHandler(
        agentCard,
        store,
        A2ATestAgentExecutorThrows(),
        busManager,
      );
      final params = A2AMessageSendParams();
      final task = A2ATask()..id = '1';
      await store.save(task);
      final message = A2AMessage()
        ..taskId = '1'
        ..contextId = '100';
      params.message = message;
      await expectLater(
        drq.sendMessageStream(params).first,
        throwsA(isA<A2AInvalidParamsError>()),
      );
      message.messageId = '100';
      final event = await drq.sendMessageStream((params)).first;
      final eventBus = busManager.getByTaskId('1');
      expect(eventBus, isNull);
      expect(event is A2ATaskStatusUpdateEvent, isTrue);
      final update = event as A2ATaskStatusUpdateEvent;
      expect(event.contextId, '100');
      expect(update.end, isTrue);
      expect(update.taskId, '1');
      expect(update.status?.state, A2ATaskState.failed);
      expect(update.status?.timestamp?.length, 23);
      final updateMessage = update.status?.message;
      expect(updateMessage, isNotNull);
      expect(updateMessage?.messageId.isNotEmpty, isTrue);
      expect(updateMessage?.taskId, '1');
      expect(updateMessage?.contextId, '100');
      expect(
        (updateMessage?.parts?.first as A2ATextPart).text,
        'Agent execution error: Invalid argument(s): Argument Error from execute',
      );
    });
    test('Send Message Stream - Normal Executor', () async {
      final agentCard = A2AAgentCard();
      final store = A2AInMemoryTaskStore();
      final eventBus = A2ATestAgentExecutor();
      final busManager = A2ADefaultExecutionEventBusManager();
      final drq = A2ADefaultRequestHandler(
        agentCard,
        store,
        eventBus,
        busManager,
      );
      final params = A2AMessageSendParams();
      final task = A2ATask()..id = '1';
      await store.save(task);
      final message = A2AMessage()
        ..taskId = '1'
        ..contextId = '100';
      params.message = message;
      message.messageId = '100';
      int eventCount = 0;
      await for (final event in drq.sendMessageStream((params))) {
        if (event is A2ATask) {
          expect(event.contextId, '100');
          expect(event.id, '1');
          expect(event.status?.state, A2ATaskState.submitted);
        }
        if (event is A2ATaskStatusUpdateEvent) {
          if (event.end != null && event.end!) {
            expect(event.status?.state, A2ATaskState.completed);
          } else {
            expect(event.status?.state, A2ATaskState.working);
          }
        }
        eventCount++;
      }
      expect(eventCount, 3);
      expect(eventBus, isNotNull);
    });
    test('Send Message - Error in Executor - Non Blocking', () async {
      final agentCard = A2AAgentCard();
      final store = A2AInMemoryTaskStore();
      final busManager = A2ADefaultExecutionEventBusManager();
      final drq = A2ADefaultRequestHandler(
        agentCard,
        store,
        A2ATestAgentExecutorThrows(),
        busManager,
      );
      final params = A2AMessageSendParams();
      final task = A2ATask()..id = '1';
      await store.save(task);
      final message = A2AMessage()
        ..taskId = '1'
        ..contextId = '100';
      params.message = message;
      await expectLater(
        drq.sendMessageStream(params).first,
        throwsA(isA<A2AInvalidParamsError>()),
      );
      message.messageId = '100';
      final event = await drq.sendMessage((params));
      expect(event is A2ATask, isTrue);
      final update = event as A2ATask;
      expect(event.contextId, '100');
      expect(update.id, '1');
      expect(update.status?.state, A2ATaskState.failed);
      expect(update.status?.timestamp?.length, 23);
      expect(update.history, isNotNull);
      expect(update.history?.length, 1);
      expect(update.history?.first.messageId, '100');
      final updateMessage = update.status?.message;
      expect(updateMessage, isNotNull);
      expect(updateMessage?.messageId.isNotEmpty, isTrue);
      expect(updateMessage?.taskId, '1');
      expect(updateMessage?.contextId, '100');
      expect(
        (updateMessage?.parts?.first as A2ATextPart).text,
        'Agent execution error: Invalid argument(s): Argument Error from execute',
      );
    });
    test('Send Message - Error in Executor - Blocking', () async {
      final agentCard = A2AAgentCard();
      final store = A2AInMemoryTaskStore();
      final busManager = A2ADefaultExecutionEventBusManager();
      final drq = A2ADefaultRequestHandler(
        agentCard,
        store,
        A2ATestAgentExecutorThrows(),
        busManager,
      );
      final params = A2AMessageSendParams()
      ..configuration = (A2AMessageSendConfiguration()
          ..blocking = true);
      final task = A2ATask()..id = '1';
      await store.save(task);
      final message = A2AMessage()
        ..taskId = '1'
        ..contextId = '100';
      params.message = message;
      await expectLater(
        drq.sendMessageStream(params).first,
        throwsA(isA<A2AInvalidParamsError>()),
      );
      message.messageId = '100';
      final event = await drq.sendMessage((params));
      expect(event is A2ATask, isTrue);
      final update = event as A2ATask;
      expect(event.contextId, '100');
      expect(update.id, '1');
      expect(update.status?.state, A2ATaskState.failed);
      expect(update.status?.timestamp?.length, 23);
      expect(update.history, isNotNull);
      expect(update.history?.length, 2);
      expect(update.history?.first.messageId, '100');
      final updateMessage = update.status?.message;
      expect(updateMessage, isNotNull);
      expect(updateMessage?.messageId.isNotEmpty, isTrue);
      expect(updateMessage?.taskId, '1');
      expect(updateMessage?.contextId, '100');
      expect(
        (updateMessage?.parts?.first as A2ATextPart).text,
        'Agent execution error: Invalid argument(s): Argument Error from execute',
      );
    });
  });
}
