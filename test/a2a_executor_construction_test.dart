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

  final rq = A2ARequestContext(testMessage, testTask, [], taskId, contextId);

  final ev = A2ADefaultExecutionEventBus();

  test('Construction', () async {
    final ec = A2AExecutorConstructor(rq, ev);
    expect(ec.contextId, contextId);
    expect(ec.taskId, taskId);
    expect(ec.userMessage.messageId, messageId);
    expect(ec.existingTask?.id, taskId);
    expect(ec.referencedTasks, []);
    expect(ec.isTaskCancelled, isFalse);
  });
}
