/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// JSON-RPC response for the 'tasks/cancel' method.
base class A2ACancelTaskResponse {}

final class JSONRPCErrorResponse extends A2ACancelTaskResponse
    with JSONRPCErrorResponseM {}

final class CancelTaskSuccessResponse extends A2ACancelTaskResponse {}

mixin JSONRPCErrorResponseM {
  late A2AError error;

  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  late (String, num) id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  String jsonrpc = '2.0';
}
