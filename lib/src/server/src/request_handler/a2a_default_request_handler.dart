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

const nonCancelableStates = [
  A2ATaskState.completed,
  A2ATaskState.failed,
  A2ATaskState.canceled,
  A2ATaskState.rejected,
];

const finalStates = [
  A2ATaskState.completed,
  A2ATaskState.failed,
  A2ATaskState.canceled,
  A2ATaskState.rejected,
];

class A2ADefaultRequestHandler implements A2ARequestHandler {
  final A2AAgentCard _agentCard;

  final A2AAgentCard? _extendedAgentCard;

  final A2ATaskStore _taskStore;

  final A2AAgentExecutor _agentExecutor;

  final A2AExecutionEventBusManager _eventBusManager;

  final _uuid = Uuid();

  // Store for push notification configurations (could be part of TaskStore or separate)
  final Map<String, List<A2APushNotificationConfig>> _pushNotificationConfigs =
      {};

  @override
  Future<A2AAgentCard> get agentCard async => _agentCard;

  @override
  Future<A2AAgentCard> get authenticatedExtendedAgentCard async {
    if (_extendedAgentCard == null) {
      throw A2AServerError.authenticatedExtendedCardNotConfigured();
    }

    return _extendedAgentCard;
  }

  A2ADefaultRequestHandler(
    this._agentCard,
    this._taskStore,
    this._agentExecutor,
    this._eventBusManager,
    this._extendedAgentCard,
  );

  /// This method can be blocking or non blocking as selected by the blocking flag
  /// in [params.configuration].
  ///
  /// If blocking is selected the method can simply be awaited to return the
  /// final resolved result in the success property of the [A2AResultResolver]
  ///
  /// In non-blocking mode the success property holds a Future that you must
  /// resolve to get the result.
  ///
  /// For both blocking or non blocking calls if an error occurs the resolved
  /// error value will be in the error property.
  @override
  Future<A2AResultResolver> sendMessage(A2AMessageSendParams params) async {
    final completer = Completer<A2AResultResolver>();
    final incomingMessage = params.message;
    if (incomingMessage.messageId.isEmpty) {
      throw A2AServerError.invalidParams(
        'A2ADefaultRequestHandler::sendMessage message.messageId is required.',
        null,
      );
    }

    // Default to blocking behavior even if 'blocking' is false
    bool isBlocking = true;
    if (params.configuration != null &&
        params.configuration?.blocking == false) {
      print(
        '${Colorize('A2ADefaultRequestHandler::sendMessage '
        'Non blocking request selected, ignoring, request will be treated as blocking').yellow()}',
      );
    }

    final taskId = incomingMessage.taskId ?? _uuid.v4();

    // Instantiate ResultManager before creating RequestContext
    final resultManager = A2AResultManager(_taskStore);
    resultManager.context = incomingMessage;

    final requestContext = await _createRequestContext(
      incomingMessage,
      taskId,
      false,
    );
    // Use the (potentially updated) contextId from requestContext
    final finalMessageForAgent = requestContext.userMessage;

    final eventBus = _eventBusManager.createOrGetByTaskId(taskId);
    // EventQueue should be attached to the bus, before the agent execution begins.
    final eventQueue = A2AExecutionEventQueue(eventBus!);

    // Start agent execution (non-blocking).
    // It runs in the background and publishes events to the eventBus.
    await _agentExecutor.execute(requestContext, eventBus).catchError((err) {
      print(
        '${Colorize('A2ADefaultRequestHandler::sendMessage '
        'Agent execution failed for message ${finalMessageForAgent.messageId}, error is $err').red()}',
      );
      // Publish a synthetic error event, which will be handled by the ResultManager
      // and will also settle the firstResultPromise for non-blocking calls.
      final errorTask = A2ATask()
        ..id = requestContext.task?.id ?? _uuid.v4()
        ..contextId = finalMessageForAgent.contextId!
        ..status = (A2ATaskStatus()
          ..state = A2ATaskState.failed
          ..message = (A2AMessage()
            ..messageId = _uuid.v4()
            ..parts = ([A2ATextPart()..text = 'Agent execution error: $err'])
            ..taskId = requestContext.task?.id
            ..contextId = finalMessageForAgent.contextId)
          ..timestamp = A2AUtilities.getCurrentTimestamp())
        ..history = requestContext.task?.history ?? [];

      // Add incoming message to history
      if (!errorTask.history!.contains(finalMessageForAgent)) {
        errorTask.history?.add(finalMessageForAgent);
      }
      eventBus.publish(errorTask);
      // And publish a final status update
      eventBus.publish(
        A2ATaskStatusUpdateEvent()
          ..taskId = errorTask.id
          ..contextId = errorTask.contextId
          ..status = errorTask.status
          ..end = true,
      );
    });

    final resolver = A2AResultResolver();
    if (isBlocking) {
      // In blocking mode, wait for the full processing to complete.
      await _processEvents(taskId, resultManager, eventQueue);
      final finalResult = resultManager.finalResult;
      if (finalResult == null) {
        throw A2AServerError.internalError(
          'A2ADefaultRequestHandler::sendMessage '
          'Agent execution finished without a result, and no task context found.',
          null,
        );
      }
      resolver.result = finalResult;
      completer.complete(resolver);
    } // else { Non blocking response - not yet implemented
    // In non-blocking mode, return a Future that will be settled by fullProcessing.
    // resolver.result = _processEvents(taskId, resultManager, eventQueue);
    // completer.complete(resolver);
    //}
    return completer.future;
  }

  @override
  Stream<A2AResult> sendMessageStream(A2AMessageSendParams params) async* {
    final incomingMessage = params.message;
    if (incomingMessage.messageId.isEmpty) {
      throw A2AServerError.invalidParams(
        'A2ADefaultRequestHandler::sendMessageStream message.messageId is required.',
        null,
      );
    }

    final taskId = incomingMessage.taskId ?? _uuid.v4();

    // Instantiate ResultManager before creating RequestContext
    final resultManager = A2AResultManager(_taskStore);
    resultManager.context = incomingMessage;

    final requestContext = await _createRequestContext(
      incomingMessage,
      taskId,
      false,
    );
    final finalMessageForAgent = requestContext.userMessage;

    final eventBus = _eventBusManager.createOrGetByTaskId(taskId);
    final eventQueue = A2AExecutionEventQueue(eventBus!);

    // Start agent execution (non-blocking).
    await _agentExecutor.execute(requestContext, eventBus).catchError((err) {
      print(
        '${Colorize('A2ADefaultRequestHandler::sendMessageStream '
        'Agent execution failed for stream message ${finalMessageForAgent.messageId}, error is $err').red()}',
      );
      // Publish a synthetic error event, which will be handled by the ResultManager
      final errorTaskStatus = A2ATaskStatusUpdateEvent()
        ..taskId = requestContext.task?.id ?? _uuid.v4()
        ..contextId = finalMessageForAgent.contextId!
        ..status = (A2ATaskStatus()
          ..state = A2ATaskState.failed
          ..message = (A2AMessage()
            ..messageId = _uuid.v4()
            ..parts = ([A2ATextPart()..text = 'Agent execution error: $err'])
            ..taskId = requestContext.task?.id
            ..contextId = finalMessageForAgent.contextId)
          ..timestamp = A2AUtilities.getCurrentTimestamp())
        ..end = true;

      eventBus.publish(errorTaskStatus);
    });

    try {
      await for (final event in eventQueue.events()) {
        await resultManager.processEvent(event); // Update store in background
        yield event; // Stream the event to the client
      }
    } finally {
      // Cleanup when the stream is fully consumed or breaks
      _eventBusManager.cleanupByTaskId(taskId);
    }
  }

  @override
  Future<A2ATask> getTask(A2ATaskQueryParams params) async {
    final task = await _taskStore.load(params.id);
    if (task == null) {
      throw A2AServerError.taskNotFound(params.id);
    }

    if (params.historyLength != null && params.historyLength! >= 0) {
      if (task.history != null) {
        task.history = task.history?.sublist(0, params.historyLength!);
      }
    } else {
      // Negative or invalid historyLength means no history
      task.history = [];
    }

    return task;
  }

  @override
  Future<A2ATask> cancelTask(A2ATaskIdParams params) async {
    final task = await _taskStore.load(params.id);
    if (task == null) {
      throw A2AServerError.taskNotFound(params.id);
    }

    // Check if task is in a cancelable state
    if (task.status?.state == null ||
        nonCancelableStates.contains(task.status?.state)) {
      throw A2AServerError.taskNotCancelable(params.id);
    }

    final eventBus = _eventBusManager.getByTaskId(params.id);

    if (eventBus != null) {
      await _agentExecutor.cancelTask(params.id, eventBus);
    } else {
      // Here we are marking task as cancelled.
      // We are not waiting for the executor to actually cancel processing.

      // Add a system message indicating cancellation
      final message = A2AMessage()
        ..messageId = _uuid.v4()
        ..parts = [A2ATextPart()..text = 'Task cancellation requested by user.']
        ..taskId = task.id
        ..contextId = task.contextId;

      task.status
        ?..state = A2ATaskState.canceled
        ..message = message
        ..timestamp = A2AUtilities.getCurrentTimestamp();

      // Add cancellation message to history
      task.history ??= [];
      task.history?.add(message);

      await _taskStore.save(task);
    }

    return (await _taskStore.load(params.id))!;
  }

  @override
  Future<A2ATaskPushNotificationConfig>? setTaskPushNotificationConfig(
    A2ATaskPushNotificationConfig params,
  ) async {
    final completer = Completer<A2ATaskPushNotificationConfig>();
    if (_agentCard.capabilities.pushNotifications == false) {
      throw A2AServerError.pushNotificationNotSupported();
    }

    final taskAndHistory = await _taskStore.load(params.taskId);
    if (taskAndHistory == null) {
      throw A2AServerError.taskNotFound(params.taskId);
    }

    // Default the config ID to the task ID if not provided for backward compatibility.
    params.pushNotificationConfig?.id ??= params.taskId;

    // Add or update the configuration
    _pushNotificationConfigs[params.taskId] ??= [];
    int? index = _pushNotificationConfigs[params.taskId]?.indexOf(
      params.pushNotificationConfig!,
    );
    if (index == -1) {
      _pushNotificationConfigs[params.taskId]?.add(
        params.pushNotificationConfig!,
      );
    } else {
      _pushNotificationConfigs[params.taskId]?[index!] =
          params.pushNotificationConfig!;
    }

    completer.complete(
      A2ATaskPushNotificationConfig()
        ..pushNotificationConfig = params.pushNotificationConfig
        ..taskId = params.taskId,
    );

    return completer.future;
  }

  @override
  Future<A2ATaskPushNotificationConfig>? getTaskPushNotificationConfig(
    A2AGetTaskPushNotificationConfigParams params,
  ) async {
    final completer = Completer<A2ATaskPushNotificationConfig>();
    if (_agentCard.capabilities.pushNotifications == false) {
      throw A2AServerError.pushNotificationNotSupported();
    }

    final task = await _taskStore.load(params.id);
    if (task == null) {
      throw A2AServerError.taskNotFound(params.id);
    }

    final configs = _pushNotificationConfigs[params.id];
    if (configs == null) {
      throw A2AServerError.internalError(
        ''
        'Push notification config not found for task ${params.id}.',
        null,
      );
    }
    int index = configs.indexWhere(
      (e) => e.id == params.pushNotificationConfigId,
    );
    if (index == -1) {
      throw A2AServerError.internalError(
        ''
        'Push notification config not found for task ${params.id}.',
        null,
      );
    }

    completer.complete(
      A2ATaskPushNotificationConfig()
        ..pushNotificationConfig = configs[index]
        ..taskId = params.id,
    );

    return completer.future;
  }

  @override
  Future<List<A2ATaskPushNotificationConfig>>? listTaskPushNotificationConfigs(
    A2AListTaskPushNotificationConfigParams params,
  ) async {
    final completer = Completer<List<A2ATaskPushNotificationConfig>>();
    if (_agentCard.capabilities.pushNotifications == false) {
      throw A2AServerError.pushNotificationNotSupported();
    }

    final task = await _taskStore.load(params.id);
    if (task == null) {
      throw A2AServerError.taskNotFound(params.id);
    }

    final taskList = <A2ATaskPushNotificationConfig>[];
    if (_pushNotificationConfigs.containsKey(params.id)) {
      for (final config in _pushNotificationConfigs[params.id]!) {
        taskList.add(
          A2ATaskPushNotificationConfig()
            ..pushNotificationConfig = config
            ..taskId = params.id,
        );
      }
    }
    completer.complete(taskList);

    return completer.future;
  }

  @override
  Future<void> deleteTaskPushNotificationConfig(
    A2ADeleteTaskPushNotificationConfigParams params,
  ) async {
    if (_agentCard.capabilities.pushNotifications == false) {
      throw A2AServerError.pushNotificationNotSupported();
    }

    final task = await _taskStore.load(params.id);
    if (task == null) {
      throw A2AServerError.taskNotFound(params.id);
    }

    final configs = _pushNotificationConfigs[params.id];

    configs!.removeWhere((e) => e.id == params.id);

    return;
  }

  @override
  Stream<A2AResult> resubscribe(A2ATaskIdParams params) async* {
    if (_agentCard.capabilities.streaming == false) {
      throw A2AServerError.unsupportedOperation(
        'Streaming (and thus resubscription) '
        'is not supported.',
      );
    }

    final task = await _taskStore.load(params.id);
    if (task == null) {
      throw A2AServerError.taskNotFound(params.id);
    }

    // Yield the current task state first
    yield task;

    // If task is already in a final state, no more events will come.
    if (finalStates.contains(task.status?.state)) {
      return;
    }

    final eventBus = _eventBusManager.getByTaskId(params.id);
    if (eventBus == null) {
      // No active execution for this task, so no live events.
      print(
        '${Colorize('Resubscribe: No active event bus for task ${params.id}.').yellow()}',
      );
      return;
    }

    // Attach a new queue to the existing bus for this resubscription
    final eventQueue = A2AExecutionEventQueue(eventBus);
    // Note: The ResultManager part is already handled by the original execution flow.
    // Resubscribe just listens for new events.

    try {
      await for (final event in eventQueue.events()) {
        // We only care about updates related to *this* task.
        // The event bus might be shared if messageId was reused, though
        // ExecutionEventBusManager tries to give one bus per original message.
        if (event is A2ATaskStatusUpdateEvent && event.taskId == params.id) {
          yield event;
        } else if (event is A2ATaskArtifactUpdateEvent &&
            event.taskId == params.id) {
          yield event;
        } else if (event is A2ATask && event.id == params.id) {
          // This implies the task was re-emitted, yield it.
          yield event;
        }
        // We don't yield 'message' events on resubscribe typically,
        // as those signal the end of an interaction for the *original* request.
        // If a 'message' event for the original request terminates the bus, this loop will also end.
      }
    } finally {
      eventQueue.stop();
    }
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
    final contextId = messageForContext.contextId ??=
        task?.contextId ?? _uuid.v4();
    messageForContext.contextId = contextId;

    return A2ARequestContext(
      messageForContext,
      task,
      referenceTasks,
      taskId,
      contextId,
    );
  }

  Future<A2AResultResolver> _processEvents(
    String taskId,
    A2AResultManager resultManager,
    A2AExecutionEventQueue eventQueue,
  ) async {
    bool firstResultSent = false;
    final resolver = A2AResultResolver();
    final completer = Completer<A2AResultResolver>();
    try {
      await for (final event in eventQueue.events()) {
        await resultManager.processEvent(event);
      }
      final result = resultManager.finalResult;
      if (result != null && resolver.result == null && !firstResultSent) {
        if (result is A2AMessage || result is A2ATask) {
          resolver.result = result;
          firstResultSent = true;
        }
      }

      if (resolver.error == null && !firstResultSent) {
        final error = A2AServerError.internalError(
          'A2ADefaultRequestHandler::_processEvents '
          'Execution finished before a message or task was produced.',
          null,
        );
        resolver.error = error;
      }
      completer.complete(resolver);
    } catch (e) {
      print(
        '${Colorize('A2ADefaultRequestHandler::_processEvents '
        'Event processing loop failed for task $taskId.').red()}',
      );
      if (!firstResultSent) {
        resolver.error = e;
      }
      rethrow;
    } finally {
      _eventBusManager.cleanupByTaskId(taskId);
    }

    return completer.future;
  }
}

/// Use to pass success or fail values back to the caller of a function.
/// Only one value should be set.
class A2AResultResolver {
  /// Success
  Object? result;

  /// Error
  Object? error;
}
