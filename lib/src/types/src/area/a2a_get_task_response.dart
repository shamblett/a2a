/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// JSON-RPC response for the 'tasks/get' method.
base class A2AGetTaskResponse {}

final class A2AJSONRPCErrorResponseT extends A2AGetTaskResponse
    with A2AJSONRPCErrorResponseM {}

/// JSON-RPC success response for the 'tasks/get' method.
final class A2AGetTaskSuccessResponse extends A2AGetTaskResponse {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';
  A2ATask? result;
}
