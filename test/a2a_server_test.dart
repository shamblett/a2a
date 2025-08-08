/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

@TestOn('vm')
library;

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
}
