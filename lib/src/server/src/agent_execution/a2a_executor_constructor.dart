/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_server.dart';

/// Simplifies the construction of executors
class A2AExecutorConstructor {
  /// User supplied initial task update, state should be submitted.
  A2ATask? initialTaskUpdate;

  /// User supplied working task status update, state should be working
  /// end should be false.
  A2ATaskStatusUpdateEvent? workingUpdate;

  /// User supplied final task status update, state should be completed,
  /// end should be true.
  A2ATaskStatusUpdateEvent? finalUpdate;

  final _uuid = Uuid();

  bool _taskCancelled = false;

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

  /// Referenced tasks
  List<A2ATask>? get referencedTasks => _requestContext.referenceTasks;

  /// Returns true if the task is cancelled.
  /// Use this if you wish to perform your own task cancellation functionality.
  /// if you want the task to be automatically cancelled then use
  /// [hasTaskBeenCancelled].
  bool get isTaskCancelled => _taskCancelled;

  /// If the id of the task to cancel is the id of
  /// our task mark the task as cancelled.
  set cancelTask(String id) {
    if (id == taskId) {
      _taskCancelled = true;
    }
  }

  A2AExecutorConstructor(this._requestContext, this._eventBus);

  /// If the task has been cancelled this method will automatically
  /// send a cancel task event. If you wish to use your own task cancellation
  /// functionality use [isTaskCancelled]
  ///
  /// Returns true if the task has been cancelled.
  bool hasTaskBeenCancelled() {
    if (_taskCancelled) {
      publishCancelTaskUpdate();
      return true;
    }
    return false;
  }

  /// Publishes the initial task update if there is no user
  /// supplied initial task..
  void publishInitialTaskUpdate() {
    final initialTask = A2ATask()
      ..id = taskId
      ..contextId = contextId
      ..status = (A2ATaskStatus()
        ..state = A2ATaskState.submitted
        ..timestamp = A2AUtilities.getCurrentTimestamp())
      ..history = [userMessage]
      ..metadata = userMessage.metadata
      ..artifacts = [];

    var task = initialTaskUpdate ?? initialTask;
    _eventBus.publish(task);
    _requestContext.task = task;
  }

  /// Publish working task update
  void publishWorkingTaskUpdate({List<A2APart>? part}) {
    final workingStatusUpdate = A2ATaskStatusUpdateEvent()
      ..taskId = taskId
      ..contextId = contextId
      ..status = (A2ATaskStatus()
        ..state = A2ATaskState.working
        ..message = (A2AMessage()
          ..role = 'agent'
          ..messageId = _uuid.v4()
          ..parts = part ?? []
          ..taskId = taskId
          ..contextId = contextId)
        ..timestamp = A2AUtilities.getCurrentTimestamp())
      ..end = false;

    var update = workingUpdate ?? workingStatusUpdate;
    _eventBus.publish(update);
  }

  /// Publish final task update
  void publishFinalTaskUpdate({List<A2APart>? part}) {
    final finalStatusUpdate = A2ATaskStatusUpdateEvent()
      ..taskId = taskId
      ..contextId = contextId
      ..status = (A2ATaskStatus()
        ..state = A2ATaskState.completed
        ..message = (A2AMessage()
          ..role = 'agent'
          ..messageId = _uuid.v4()
          ..parts = part ?? []
          ..taskId = taskId
          ..contextId = contextId)
        ..timestamp = A2AUtilities.getCurrentTimestamp())
      ..end = true;

    var update = finalUpdate ?? finalStatusUpdate;
    _eventBus.publish(update);
  }

  /// Publish cancel task update
  void publishCancelTaskUpdate() {
    final cancelledUpdate = A2ATaskStatusUpdateEvent()
      ..taskId = taskId
      ..contextId = contextId
      ..status = (A2ATaskStatus()
        ..state = A2ATaskState.canceled
        ..timestamp = A2AUtilities.getCurrentTimestamp())
      ..end = true;
    _eventBus.publish(cancelledUpdate);
  }

  /// Delay processing, period is milliseconds.
  void delay(int period) async {
    await Future.delayed(Duration(milliseconds: period));
  }

  /// Publish an Artifact update
  void publishArtifactUpdate(
    String name,
    String id,
    List<A2APart> parts, {
    bool append = false,
    bool lastChunk = false,
  }) {
    final artifactUpdate = A2ATaskArtifactUpdateEvent()
      ..taskId = taskId
      ..contextId = contextId
      ..artifact = (A2AArtifact()
        ..artifactId = id
        ..name = name
        ..parts = parts)
      ..append = append
      ..lastChunk = lastChunk;
    _eventBus.publish(artifactUpdate);
  }

  /// Publish the final task update to mark execution complete
  /// The message sent with the update can have optional parts.
  void publishFinalUpdate(String messageId, {List<A2APart>? messageParts}) {
    final finalUpdate = A2ATaskStatusUpdateEvent()
      ..taskId = taskId
      ..contextId = contextId
      ..status = (A2ATaskStatus()
        ..state = A2ATaskState.completed
        ..message = (A2AMessage()
          ..role = 'agent'
          ..messageId = messageId
          ..taskId = taskId
          ..contextId = contextId)
        ..timestamp = A2AUtilities.getCurrentTimestamp())
      ..end = true;

    if (messageParts != null) {
      finalUpdate.status?.message?.parts = messageParts;
    }
    _eventBus.publish(finalUpdate);
  }

  /// Publish a user supplied entity.
  /// Used for publishing specific created objects.
  void publishUserObject(Object object) {
    _eventBus.publish(object);
  }

  /// Create a text part.
  A2ATextPart createTextPart(String text, {A2ASV? metadata}) {
    final textPart = A2ATextPart()..text = text;
    if (metadata != null) {
      textPart.metadata = metadata;
    }
    return textPart;
  }

  /// Create a URL file part.
  A2AFilePart createUrlFilePart(
    String uri, {
    String? name,
    A2ASV? metadata,
    String? mimetype,
  }) {
    final filePart = A2AFilePart();
    if (metadata != null) {
      filePart.metadata = metadata;
    }
    final fileWithUrl = A2AFileWithUri();
    if (name != null) {
      fileWithUrl.name = name;
    }
    if (mimetype != null) {
      fileWithUrl.mimeType = mimetype;
    }
    fileWithUrl.uri = uri;

    filePart.file = fileWithUrl;

    return filePart;
  }

  /// Create a bytes file part.
  /// The bytes parameter is the base64 encoded content of the file.
  A2AFilePart createUrlBytesFilePart(
    String bytes, {
    String? name,
    A2ASV? metadata,
    String? mimetype,
  }) {
    final filePart = A2AFilePart();
    if (metadata != null) {
      filePart.metadata = metadata;
    }
    final fileWithBytes = A2AFileWithBytes();
    if (name != null) {
      fileWithBytes.name = name;
    }
    if (mimetype != null) {
      fileWithBytes.mimeType = mimetype;
    }
    fileWithBytes.bytes = bytes;

    filePart.file = fileWithBytes;

    return filePart;
  }

  /// Create a data part.
  A2ADataPart createDataPart(A2ASV data, {A2ASV? metadata}) {
    final dataPart = A2ADataPart()..data = data;
    if (metadata != null) {
      dataPart.metadata = metadata;
    }
    return dataPart;
  }
}
