/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

@TestOn('vm')
library;

import 'dart:async';

import 'package:a2a/a2a.dart';
import 'package:test/test.dart';

import 'package:a2a/src/server/a2a_server.dart';

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
    test('First No Status', () async {
      final store = A2AInMemoryTaskStore();
      final rm = A2AResultManager(store);
      final artifactUpdate = A2ATaskArtifactUpdateEvent()..taskId = '10';
      unawaited(rm.processEvent(artifactUpdate));
      expect(store.count, 0);
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
      artifact.description = 'The description';
    });
    test('Subsequent with append', () async {
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
  });
}
