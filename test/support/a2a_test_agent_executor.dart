// ignore_for_file: unawaited_futures

/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

import 'dart:async';

import 'package:a2a/src/server/a2a_server.dart';
import 'package:colorize/colorize.dart';

/// Mock
class A2ATestAgentExecutor implements A2AAgentExecutor {
  @override
  Future<void> execute(
    A2ARequestContext requestContext,
    A2AExecutionEventBus eventBus,
  ) async {
    print('${Colorize('A2ATestAgentExecutor EXECUTE invoked')..blue()}');

    final task = A2ATask()
      ..id = requestContext.taskId
      ..contextId = requestContext.contextId
      ..status = (A2ATaskStatus()
        ..state = A2ATaskState.submitted
        ..timestamp = A2AUtilities.getCurrentTimestamp());

    final taskUpdate = A2ATaskStatusUpdateEvent()
      ..contextId = requestContext.contextId
      ..taskId = requestContext.taskId
      ..end = false
      ..status = (A2ATaskStatus()..state = (A2ATaskState.working));

    eventBus.publish(task);
    eventBus.publish(taskUpdate);

    // Simulate work
    await Future.delayed(Duration(seconds: 1));

    final taskUpdateComplete = A2ATaskStatusUpdateEvent()
      ..contextId = requestContext.contextId
      ..taskId = requestContext.taskId
      ..end = true
      ..status = (A2ATaskStatus()..state = (A2ATaskState.completed));
    eventBus.publish(taskUpdateComplete);
  }

  @override
  Future<void> cancelTask(String taskId, A2AExecutionEventBus eventBus) async {
    print(
      '${Colorize('A2ATestAgentExecutor Cancel Task invoked for task $taskId')..blue()}',
    );
    await Future.delayed(Duration(seconds: 1));
  }
}

/// Mock that throws future errors
class A2ATestAgentExecutorThrows implements A2AAgentExecutor {
  @override
  Future<void> execute(
    A2ARequestContext requestContext,
    A2AExecutionEventBus eventBus,
  ) async {
    final completer = Completer<void>();
    print('${Colorize('A2ATestAgentExecutorThrows EXECUTE invoked')..blue()}');
    Future.delayed(Duration(seconds: 1)).then((_) {
      completer.completeError(ArgumentError('Argument Error from execute'));
    });
    return completer.future;
  }

  @override
  Future<void> cancelTask(String taskId, A2AExecutionEventBus eventBus) async {
    print(
      '${Colorize('A2ATestAgentExecutorThrows Cancel Task invoked')..blue()}',
    );
    await Future.delayed(Duration(seconds: 1));
  }
}
