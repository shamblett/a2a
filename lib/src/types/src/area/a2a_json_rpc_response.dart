/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// Represents a JSON-RPC 2.0 Response object.
sealed class A2AJsonRpcResponse {}

final class A2AJSONRPCErrorResponseR extends A2AJsonRpcResponse
    with A2AJSONRPCErrorResponseM {}

/// JSON-RPC success response model for the 'message/send' method.
final class A2ASendMessageSuccessResponse extends A2AJsonRpcResponse {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';

  /// The result object on success, [A2ATask} or [A2AMessage]
  Object? result;
}

/// JSON-RPC success response model for the 'message/stream' method.
final class A2ASendStreamingMessageSuccessResponse extends A2AJsonRpcResponse {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';

  /// The result object on success, [A2ATask}, [A2AMessage], [A2ATaskStatusUpdateEvent] or
  /// [A2ATaskArtifactUpdateEvent]
  Object? result;
}

/// JSON-RPC success response model for the 'tasks/pushNotificationConfig/set' method.
final class A2ASetTaskPushNotificationConfigSuccessResponse
    extends A2AJsonRpcResponse {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';
  A2ATaskPushNotificationConfig1? result;
}
