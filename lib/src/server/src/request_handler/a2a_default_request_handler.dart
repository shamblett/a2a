/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_server.dart';

const terminalStates = [
  A2ATaskState.completed,
  A2ATaskState.failed,
  A2ATaskState.canceled,
  A2ATaskState.rejected,
];

class A2ADefaultRequestHandler implements A2ARequestHandler {
  final A2AAgentCard _agentCard;

  final A2ATaskStore _taskStore;

  final A2AAgentExecutor _agentExecutor;

  final A2AExecutionEventBusManager _eventBusManager;

  final _uuid = Uuid();

  // Store for push notification configurations (could be part of TaskStore or separate)
  final Map<String, A2APushNotificationConfig> _pushNotificationConfigs = {};

  @override
  Future<A2AAgentCard> get agentCard async => _agentCard;

  A2ADefaultRequestHandler(
    this._agentCard,
    this._taskStore,
    this._agentExecutor,
    this._eventBusManager,
  );

  Future<A2ARequestContext> _createRequestContext(
    A2AMessage incomingMessage,
    String taskId,
    bool isStream,
  ) async {
    A2ATask? task;
    List<A2ATask>? referenceTasks;

    // IncomingMessage would contain taskId, if a task already exists.
    if (incomingMessage.taskId != null) {
      task = await _taskStore.load(incomingMessage.taskId!);
      if (task == null) {
        throw A2AServerError.taskNotFound(incomingMessage.taskId!);
      }

      if (terminalStates.contains(task.status?.state)) {
        // Throw an error that conforms to the JSON-RPC Invalid Request error specification.
        throw A2AServerError.invalidRequest(
          'A2ADefaultRequestHandler::_createRequestContext Task ${task.id} is in a terminal state (${task.status?.state}) '
          'and cannot be modified.',
          null,
        );
      }
    }

    if (incomingMessage.referenceTaskIds != null &&
        incomingMessage.referenceTaskIds!.isNotEmpty) {
      referenceTasks = [];
      for (final refId in incomingMessage.referenceTaskIds!) {
        final refTask = await _taskStore.load(refId);
        if (refTask != null) {
          referenceTasks.add(refTask);
        } else {
          print(
            '${Colorize('A2ADefaultRequestHandler::_createRequestContext '
            'Reference task $refId not found.').yellow()}',
          );
          // Optionally, throw an error or handle as per specific requirements
        }
      }
    }

    // Ensure contextId is present
    final messageForContext = incomingMessage;
    if (messageForContext.contextId != null) {
      messageForContext.contextId = task?.contextId ?? _uuid.v4();
    }

    return A2ARequestContext(
      messageForContext,
      task,
      referenceTasks,
      taskId,
      messageForContext.contextId!,
    );
  }
}
