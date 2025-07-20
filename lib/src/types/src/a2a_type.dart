/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../a2a_types.dart';

class A2AType {}

/// The ID type, String or num.
typedef A2AId = Object;

/// Structured value type
typedef A2ASV = Map<String, Object>;

/// Represents the possible states of a Task.
enum A2ATaskState {
  @JsonValue('submitted')
  submitted,
  @JsonValue('working')
  working,
  @JsonValue('input-required')
  inputRequired,
  @JsonValue('completed')
  completed,
  @JsonValue('canceled')
  canceled,
  @JsonValue('failed')
  failed,
  @JsonValue('rejected')
  rejected,
  @JsonValue('auth-required')
  authRequired,
  @JsonValue('unknown')
  unknown,
}

interface class A2AMySchema {
  Map<String, Object> unknown = {};
}

/// The message being sent to the server.
@JsonSerializable(explicitToJson: true)
class A2AMessage {
  /// The context the message is associated with
  String? contextId;

  /// The URIs of extensions that are present or contributed to this Message.
  List<String>? extensions;

  /// Event type
  String kind = 'message';

  /// Identifier created by the message creator
  String messageId = '';

  /// Extension metadata.
  A2ASV? metadata;

  /// Message content
  List<A2APart>? parts = [];

  /// List of tasks referenced as context by this message.
  List<String> referenceTaskIds = [];

  /// Message sender's role, agent or user
  String role = 'agent';

  /// Identifier of task the message is related to
  String? taskId;

  A2AMessage();

  factory A2AMessage.fromJson(Map<String, dynamic> json) =>
      _$A2AMessageFromJson(json);

  Map<String, dynamic> toJson() => _$A2AMessageToJson(this);
}

/// Represents an artifact generated for a task.
@JsonSerializable(explicitToJson: true)
class A2AArtifact {
  /// Unique identifier for the artifact.
  String artifactId = '';

  /// Optional description for the artifact.
  String? description;

  /// The URIs of extensions that are present or contributed to this Artifact.
  List<String> extensions = [];

  /// Extension metadata.
  A2ASV? metadata;

  /// Optional name for the artifact.
  String? name;

  /// Artifact parts
  List<A2APart> parts = [];

  A2AArtifact();

  factory A2AArtifact.fromJson(Map<String, dynamic> json) =>
      _$A2AArtifactFromJson(json);

  Map<String, dynamic> toJson() => _$A2AArtifactToJson(this);
}

/// The result object on success.
@JsonSerializable(explicitToJson: true)
class A2ATask {
  /// Collection of artifacts created by the agent.
  List<A2AArtifact> artifacts = [];

  /// Server-generated id for contextual alignment across interactions
  String contextId = '';
  List<A2AMessage>? history;

  /// Unique identifier for the task
  String id = '';

  /// Event type
  String kind = 'task';

  /// Extension metadata.
  A2ASV? metadata;
  A2ATaskStatus? status;

  A2ATask();

  factory A2ATask.fromJson(Map<String, dynamic> json) =>
      _$A2ATaskFromJson(json);

  Map<String, dynamic> toJson() => _$A2ATaskToJson(this);
}

/// Current status of the task
@JsonSerializable(explicitToJson: true)
class A2ATaskStatus {
  A2AMessage? message;
  A2ATaskState? state;

  /// ISO 8601 datetime string when the status was recorded.
  String? timestamp;

  A2ATaskStatus();

  factory A2ATaskStatus.fromJson(Map<String, dynamic> json) =>
      _$A2ATaskStatusFromJson(json);

  Map<String, dynamic> toJson() => _$A2ATaskStatusToJson(this);
}

/// Common JSON error response mixin
mixin A2AJSONRPCErrorResponseM {
  A2AError? error;

  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  String jsonrpc = '2.0';
}
