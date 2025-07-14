/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// JSON-RPC response model for the 'message/send' method.
sealed class A2ASendMessageResponse {}

final class A2AJSONRPCErrorResponseSM extends A2ASendMessageResponse
    with A2AJSONRPCErrorResponseM {}

/// JSON-RPC success response model for the 'message/send' method.
final class A2ASendMessageSuccessResponseR extends A2ASendMessageResponse {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';

  /// The result object on success, [A2ATask] or [A2AMessage]
  Object result = Object();
}
