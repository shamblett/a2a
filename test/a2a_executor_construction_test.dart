/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

@TestOn('vm')
library;

import 'package:test/test.dart';

import 'package:a2a/src/server/a2a_server.dart';

void main() {
  const taskId = 'Test Task Id';
  const contextId = 'Test Context Id';
  const messageId = 'Message-12345';
  const artifactId = 'Artifact-3456';
  final testTask = A2ATask()
    ..contextId = contextId
    ..id = taskId
    ..history = []
    ..artifacts = []
    ..status = (A2ATaskStatus()..state = A2ATaskState.unknown);

  final testMessage = (A2AMessage()
    ..taskId = taskId
    ..contextId = contextId
    ..messageId = messageId);

  final testTaskUpdate = A2ATaskStatusUpdateEvent()
    ..status = (A2ATaskStatus()..state = A2ATaskState.unknown)
    ..contextId = contextId
    ..taskId = taskId
    ..end = false;

  final rq = A2ARequestContext(testMessage, testTask, [], taskId, contextId);

  test('Construction', () {
    final ev = A2ADefaultExecutionEventBus();
    final ec = A2AExecutorConstructor(rq, ev);
    expect(ec.contextId, contextId);
    expect(ec.taskId, taskId);
    expect(ec.userMessage.messageId, messageId);
    expect(ec.existingTask?.id, taskId);
    expect(ec.referencedTasks, []);
    expect(ec.isTaskCancelled, isFalse);
  });
  test('Cancel Task', () {
    final ev = A2ADefaultExecutionEventBus();
    final ec = A2AExecutorConstructor(rq, ev);
    ec.cancelTask = '1234';
    expect(ec.isTaskCancelled, isFalse);
    ec.cancelTask = taskId;
    expect(ec.isTaskCancelled, isTrue);
  });
  test('Initial Task Update - default', () {
    final ev = A2ADefaultExecutionEventBus();
    final ec = A2AExecutorConstructor(rq, ev);
    ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
      expect(event is A2ATask, isTrue);
      final update = event as A2ATask;
      expect(update.contextId, contextId);
      expect(update.id, taskId);
      expect(update.status?.state, A2ATaskState.submitted);
    }));
    ec.publishInitialTaskUpdate();
  });
  test('Initial Task Update - user supplied', () {
    final ev = A2ADefaultExecutionEventBus();
    final ec = A2AExecutorConstructor(rq, ev);
    ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
      expect(event is A2ATask, isTrue);
      final update = event as A2ATask;
      expect(update.contextId, contextId);
      expect(update.id, taskId);
      expect(update.status?.state, A2ATaskState.unknown);
    }));
    ec.initialTaskUpdate = testTask;
    ec.publishInitialTaskUpdate();
  });
  test('Working Task Update - default', () {
    final ev = A2ADefaultExecutionEventBus();
    final ec = A2AExecutorConstructor(rq, ev);
    ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
      expect(event is A2ATaskStatusUpdateEvent, isTrue);
      final update = event as A2ATaskStatusUpdateEvent;
      expect(update.contextId, contextId);
      expect(update.taskId, taskId);
      expect(update.status?.state, A2ATaskState.working);
    }));
    ec.publishWorkingTaskUpdate();
  });
  test('Working Task Update - user supplied', () {
    final ev = A2ADefaultExecutionEventBus();
    final ec = A2AExecutorConstructor(rq, ev);
    ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
      expect(event is A2ATaskStatusUpdateEvent, isTrue);
      final update = event as A2ATaskStatusUpdateEvent;
      expect(update.contextId, contextId);
      expect(update.taskId, taskId);
      expect(update.status?.state, A2ATaskState.unknown);
    }));
    ec.workingUpdate = testTaskUpdate;
    ec.publishWorkingTaskUpdate();
  });
  test('Final Task Update - default', () {
    final ev = A2ADefaultExecutionEventBus();
    final ec = A2AExecutorConstructor(rq, ev);
    ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
      expect(event is A2ATaskStatusUpdateEvent, isTrue);
      final update = event as A2ATaskStatusUpdateEvent;
      expect(update.contextId, contextId);
      expect(update.taskId, taskId);
      expect(update.status?.state, A2ATaskState.completed);
      expect(update.end, isTrue);
    }));
    ec.publishFinalTaskUpdate();
  });
  test('Final Task Update - user supplied', () {
    final ev = A2ADefaultExecutionEventBus();
    final ec = A2AExecutorConstructor(rq, ev);
    ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
      expect(event is A2ATaskStatusUpdateEvent, isTrue);
      final update = event as A2ATaskStatusUpdateEvent;
      expect(update.contextId, contextId);
      expect(update.taskId, taskId);
      expect(update.status?.state, A2ATaskState.unknown);
    }));
    ec.finalUpdate = testTaskUpdate;
    ec.publishFinalTaskUpdate();
  });
  test('Cancel Task Update - default', () {
    final ev = A2ADefaultExecutionEventBus();
    final ec = A2AExecutorConstructor(rq, ev);
    ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
      expect(event is A2ATaskStatusUpdateEvent, isTrue);
      final update = event as A2ATaskStatusUpdateEvent;
      expect(update.contextId, contextId);
      expect(update.taskId, taskId);
      expect(update.status?.state, A2ATaskState.canceled);
      expect(update.end, isTrue);
    }));
    ec.publishCancelTaskUpdate();
  });
  test('Cancel Task Update - user supplied', () {
    final ev = A2ADefaultExecutionEventBus();
    final ec = A2AExecutorConstructor(rq, ev);
    ev.on(A2AExecutionEventBus.a2aEBEvent, ((event) {
      expect(event is A2ATaskStatusUpdateEvent, isTrue);
      final update = event as A2ATaskStatusUpdateEvent;
      expect(update.contextId, contextId);
      expect(update.taskId, taskId);
      expect(update.status?.state, A2ATaskState.unknown);
    }));
    ec.cancelUpdate = testTaskUpdate;
    ec.publishCancelTaskUpdate();
  });
  test('Delay', () async {
    final ev = A2ADefaultExecutionEventBus();
    final ec = A2AExecutorConstructor(rq, ev);
    expect(await ec.delay(500), isFalse);
    ec.cancelTask = taskId;
    expect(await ec.delay(500), isTrue);
  });
}
