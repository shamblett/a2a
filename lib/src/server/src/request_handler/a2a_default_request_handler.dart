/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_server.dart';

typedef ResultResolver = void Function(Object value);
typedef ResultRejector = void Function(Object? reason);

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

  Future<A2ATaskOrMessage> sendMessage(A2AMessageSendParams params) async {
    final incomingMessage = params.message;
    if (incomingMessage.messageId.isEmpty) {
      throw A2AServerError.invalidParams(
        'A2ADefaultRequestHandler::sendMessage message.messageId is required.',
        null,
      );
    }

    // Default to blocking behavior if 'blocking' is not explicitly false.
    final isBlocking = params.configuration?.blocking != false;
    final taskId = incomingMessage.taskId ?? _uuid.v4();

    // Instantiate ResultManager before creating RequestContext
    final resultManager = A2AResultManager(_taskStore);
    resultManager.context = incomingMessage;

    final requestContext = await _createRequestContext(incomingMessage, taskId, false);
    // Use the (potentially updated) contextId from requestContext
    final finalMessageForAgent = requestContext.userMessage;

    final eventBus = _eventBusManager.createOrGetByTaskId(taskId);
    // EventQueue should be attached to the bus, before the agent execution begins.
    final eventQueue = A2AExecutionEventQueue(eventBus!);

    // Start agent execution (non-blocking).
    // It runs in the background and publishes events to the eventBus.
  }

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

  Future<void> _processEvents(
    String taskId,
    A2AResultManager resultManager,
    A2AExecutionEventQueue eventQueue,
    ResultResolver? firstResultResolver,
    ResultRejector? firstResultRejector,
  ) async {
    bool firstResultSent = false;

    try {
      await for (final event in eventQueue.events()) {
        if (firstResultResolver != null && !firstResultSent) {
          if (event is A2AMessage || event is A2ATask) {
            firstResultResolver(event);
            firstResultSent = true;
          }
        }
      }

      if (firstResultRejector != null && !firstResultSent) {
        final error = A2AServerError.internalError(
          'A2ADefaultRequestHandler::_processEvents '
          'Execution finished before a message or task was produced.',
          null,
        );
        firstResultRejector(error);
      }
    } catch (e) {
      print(
        '${Colorize('A2ADefaultRequestHandler::_processEvents '
        'Event processing loop failed for task $taskId.').red()}',
      );
      if (firstResultRejector != null && !firstResultSent) {
        firstResultRejector(e);
      }
      rethrow;
    } finally {
      _eventBusManager.cleanupByTaskId(taskId);
    }
  }
}
