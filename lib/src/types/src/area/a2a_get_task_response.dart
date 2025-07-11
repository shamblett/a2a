/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// JSON-RPC response for the 'tasks/get' method.
base class A2AGetTaskResponse {}

final class JSONRPCErrorResponseT extends A2AGetTaskResponse
    with JSONRPCErrorResponseM {}

final class GetTaskSuccessResponse extends A2AGetTaskResponse {}
