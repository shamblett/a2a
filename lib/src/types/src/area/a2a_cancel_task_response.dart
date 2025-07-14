/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// JSON-RPC response for the 'tasks/cancel' method.
base class A2ACancelTaskResponse {}

final class A2AJSONRPCErrorResponse extends A2ACancelTaskResponse
    with A2AJSONRPCErrorResponseM {}

/// JSON-RPC success response model for the 'tasks/cancel' method.
final class A2ACancelTaskSuccessResponse extends A2ACancelTaskResponse {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';
  A2ATask? result;
}

mixin A2AJSONRPCErrorResponseM {
  A2AError? error;

  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  String jsonrpc = '2.0';
}
