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

  final A2ATaskStore _taskStore;

  final A2AAgentExecutor _agentExecutor;

  final A2AExecutionEventBusManager _eventBusManager;

  final _uuid = Uuid();

  // Store for push notification configurations (could be part of TaskStore or separate)
  final Map<String, A2ATaskPushNotificationConfig1> _pushNotificationConfigs =
      {};

  @override
  Future<A2AAgentCard> get agentCard async => _agentCard;

  A2ADefaultRequestHandler(
    this._agentCard,
    this._taskStore,
    this._agentExecutor,
    this._eventBusManager,
  );

  @override
  Future<A2ATaskOrMessage> sendMessage(A2AMessageSendParams params) async {
    final completer = Completer<A2ATaskOrMessage>();
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
    unawaited(
      _agentExecutor.execute(requestContext, eventBus).catchError((err) {
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
      }),
    );

    if (isBlocking) {
      // In blocking mode, wait for the full processing to complete.
      await _processEvents(taskId, resultManager, eventQueue, A2AResolver());
      final finalResult = resultManager.finalResult;
      if (finalResult == null) {
        throw A2AServerError.internalError(
          'A2ADefaultRequestHandler::sendMessage '
          'Agent execution finished without a result, and no task context found.',
          null,
        );
      }
      completer.complete(finalResult);
    } else {
      // In non-blocking mode, return a Future that will be settled by fullProcessing.
      final resolver = A2AResolver();
      await _processEvents(taskId, resultManager, eventQueue, resolver);
      if (resolver.result != null) {
        completer.complete(resolver.result);
      } else if (resolver.error != null) {
        completer.completeError(resolver.error!);
      } else {
        final internalError = A2AServerError.internalError(
          'A2ADefaultRequestHandler::sendMessage no result or error '
          ' returned from _processEvents',
          null,
        );
        completer.completeError(internalError);
      }
    }

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
    unawaited(
      _agentExecutor.execute(requestContext, eventBus).catchError((err) {
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
            ..timestamp = A2AUtilities.getCurrentTimestamp());

        eventBus.publish(errorTaskStatus);
      }),
    );

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
        task.history = task.history?.sublist(-params.historyLength!);
      }
    } else {
      // Negative or invalid historyLength means no history
      task.history = [];
    }

    return task;
  }

  @override
  Future<A2ATask> cancelTask(A2ATaskQueryParams params) async {
    final task = await _taskStore.load(params.id);
    if (task == null) {
      throw A2AServerError.taskNotFound(params.id);
    }

    // Check if task is in a cancelable state
    if (nonCancelableStates.contains(task.status?.state)) {
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
    if (_agentCard.capabilities.pushNotifications == false) {
      throw A2AServerError.pushNotificationNotSupported();
    }

    final taskAndHistory = await _taskStore.load(params.taskId);
    if (taskAndHistory == null) {
      throw A2AServerError.taskNotFound(params.taskId);
    }

    // Store the config. In a real app, this might be stored in the TaskStore
    // or a dedicated push notification service.
    _pushNotificationConfigs[params.taskId] = params.pushNotificationConfig!;
    return params;
  }

  @override
  Future<A2ATaskPushNotificationConfig>? getTaskPushNotificationConfig(
    A2ATaskIdParams params,
  ) async {
    if (_agentCard.capabilities.pushNotifications == false) {
      throw A2AServerError.pushNotificationNotSupported();
    }

    final taskAndHistory = await _taskStore.load(params.id);
    if (taskAndHistory == null) {
      throw A2AServerError.taskNotFound(params.id);
    }

    final config = _pushNotificationConfigs[params.id];
    if (config == null) {
      throw A2AServerError.internalError(
        ''
        'Push notification config not found for task ${params.id}.',
        null,
      );
    }
    return A2ATaskPushNotificationConfig()
      ..pushNotificationConfig = config
      ..taskId = params.id;
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
    A2AResolver resolver,
  ) async {
    bool firstResultSent = false;

    try {
      await for (final event in eventQueue.events()) {
        if (!firstResultSent) {
          if (event is A2AMessage || event is A2ATask) {
            resolver.result = event;
            firstResultSent = true;
          }
        }
      }

      if (!firstResultSent) {
        final error = A2AServerError.internalError(
          'A2ADefaultRequestHandler::_processEvents '
          'Execution finished before a message or task was produced.',
          null,
        );
        resolver.error = error;
      }
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
  }
}

class A2AResolver {
  A2ATaskOrMessage? result;
  Object? error;
}
