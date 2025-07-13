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

final class A2AGetTaskSuccessResponse extends A2AGetTaskResponse {}
