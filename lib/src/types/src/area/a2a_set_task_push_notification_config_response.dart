/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// JSON-RPC response for the 'tasks/pushNotificationConfig/set' method.
sealed class A2ASetTaskPushNotificationConfigResponse {}

/// /// JSON RPC error response object
final class A2AJSONRPCErrorResponseSTPR
    extends A2ASetTaskPushNotificationConfigResponse
    with A2AJSONRPCErrorResponseM {}

/// JSON-RPC success response model for the 'tasks/pushNotificationConfig/set' method.
final class A2ASetTaskPushNotificationConfigSuccessResponseSTPR
    extends A2ASetTaskPushNotificationConfigResponse {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';
  A2ATaskPushNotificationConfig? result;
}
