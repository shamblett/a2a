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
      final error = A2AServerError(A2AError.unknown, 'Unknown Error', {
        'd1': 1,
      }, '10');
    });
  });
}
