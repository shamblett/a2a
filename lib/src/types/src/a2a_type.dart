/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../types.dart';

class A2AType {}

/// The ID type
typedef A2AId = (String, num);

/// Structured value type
typedef A2ASV = Map<String, Object>;

/// Represents the possible states of a Task.
enum A2ATaskState {
  submitted,
  working,
  inputRequired,
  completed,
  canceled,
  failed,
  rejected,
  authRequired,
  unknown,
}

interface class A2AMySchema {
  Map<String, Object> unknown = {};
}

/// The message being sent to the server.
class A2AMessage {
  /// The context the message is associated with
  String? contextId;

  /// The URIs of extensions that are present or contributed to this Message.
  List<String>? extensions;

  /// Event type
  final kind = 'message';

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
}

/// Represents an artifact generated for a task.
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
}
