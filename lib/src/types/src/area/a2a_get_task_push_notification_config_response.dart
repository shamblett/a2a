/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// JSON-RPC response for the 'tasks/pushNotificationConfig/get' method.
sealed class A2AGetTaskPushNotificationConfigResponse {}

final class A2AJSONRPCErrorResponseGTPR
    extends A2AGetTaskPushNotificationConfigResponse
    with A2AJSONRPCErrorResponseM {}

/// JSON-RPC success response model for the 'tasks/pushNotificationConfig/get' method.
final class A2AGetTaskPushNotificationConfigSuccessResponse
    extends A2AGetTaskPushNotificationConfigResponse {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';
  A2ATaskPushNotificationConfig1? result;
}
