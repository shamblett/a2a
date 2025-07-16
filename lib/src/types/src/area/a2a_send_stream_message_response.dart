/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// JSON-RPC response model for the 'message/send' method.
sealed class A2ASendStreamMessageResponse {}

/// JSON RPC error response object
final class A2AJSONRPCErrorResponseSSM extends A2ASendStreamMessageResponse
    with A2AJSONRPCErrorResponseM {}

/// JSON-RPC success response model for the 'message/stream' method.
final class A2ASendStreamMessageSuccessResponseR
    extends A2ASendStreamMessageResponse {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';

  /// The result object on success, [A2ATask], [A2AMessage], [A2ATaskStatusUpdateEvent]
  /// [A2ATaskArtifactUpdateEvent]
  Object? result;
}

/// Sent by server during sendStream or subscribe requests
final class A2ATaskStatusUpdateEvent {
  /// The context the task is associated with
  String contextId = '';

  /// Indicates the end of the event stream.
  /// Note, this is called 'final' in the TS code.
  bool end = false;

  /// Event type
  final kind = 'status-update';

  /// Extension metadata.
  A2ASV? metadata;
  A2ATaskStatus? status;

  /// Task Id
  String taskId = '';
}

/// Sent by server during sendStream or subscribe requests
final class A2ATaskArtifactUpdateEvent {
  /// Indicates if this artifact appends to a previous one
  bool? append;
  A2AArtifact? artifact;

  /// The context the task is associated with
  String contextId = '';

  /// Event type
  final kind = 'artifact-update';

  /// Indicates if this is the last chunk of the artifact
  bool? lastChunk;

  /// Extension metadata.
  A2ASV? metadata;

  /// Task Id
  String taskId = '';
}
