/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// JSON-RPC response for the 'tasks/cancel' method.
base class A2ACancelTaskResponse {}

final class JSONRPCErrorResponse extends A2ACancelTaskResponse {}

final class CancelTaskSuccessResponse extends A2ACancelTaskResponse {}
