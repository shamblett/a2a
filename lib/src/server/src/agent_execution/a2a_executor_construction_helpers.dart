// ignore_for_file: prefer-match-file-name

/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_server.dart';

/// Main executor helper class
/// Simplifies construction of executors
class A2AExecutorConstructor {
  final Set<String> _cancelledTasks = {};

  final _uuid = Uuid();

  final A2ARequestContext _requestContext;

  final A2AExecutionEventBus _eventBus;

  /// Task id
  String get taskId => _requestContext.taskId;

  /// Context id
  String get contextId => _requestContext.contextId;

  /// User message
  A2AMessage get userMessage => _requestContext.userMessage;

  /// Existing task
  A2ATask? get existingTask => _requestContext.task;

  /// Add a task to cancel
  set taskToCancel(String taskId) => _cancelledTasks.add(taskId);

  A2AExecutorConstructor(this._requestContext, this._eventBus);

  /// Publishes the initial task update if there is no existing task.
  void publishInitialTaskUpdate() {
    final initialTask = A2ATask()
      ..id = taskId
      ..contextId = contextId
      ..status = (A2ATaskStatus()
        ..state = A2ATaskState.submitted
        ..timestamp = A2AUtilities.getCurrentTimestamp())
      ..history = [userMessage]
      ..metadata = userMessage.metadata
      ..artifacts = []; // // Initialize artifacts array
    _eventBus.publish(initialTask);
  }

  /// Publish working task update
  void publishWorkingTaskUpdate() {
    final workingStatusUpdate = A2ATaskStatusUpdateEvent()
      ..taskId = taskId
      ..contextId = contextId
      ..status = (A2ATaskStatus()
        ..state = A2ATaskState.working
        ..message = (A2AMessage()
          ..role = 'agent'
          ..messageId = _uuid.v4()
          ..parts = [(A2ATextPart()..text = 'Generating code...')]
          ..taskId = taskId
          ..contextId = contextId)
        ..timestamp = A2AUtilities.getCurrentTimestamp())
      ..end = false;
    _eventBus.publish(workingStatusUpdate);
  }

  /// Publish final task update
  void publishFinalTaskUpdate() {
    final finalUpdate = A2ATaskStatusUpdateEvent()
      ..taskId = taskId
      ..contextId = contextId
      ..status = (A2ATaskStatus()
        ..state = A2ATaskState.completed
        ..message = (A2AMessage()
          ..role = 'agent'
          ..messageId = _uuid.v4()
          ..taskId = taskId
          ..contextId = contextId)
        ..timestamp = A2AUtilities.getCurrentTimestamp())
      ..end = true;
    _eventBus.publish(finalUpdate);
  }

  /// Delay processing, period is milliseconds.
  void delay(int period) async {
    await Future.delayed(Duration(milliseconds: period));
  }
}
