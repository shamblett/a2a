/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// Represents a JSON-RPC 2.0 Response object.
base class A2AJsonRpcResponse {}

final class JSONRPCErrorResponseR extends A2AJsonRpcResponse
    with JSONRPCErrorResponseM {}

final class SendMessageSuccessResponse extends A2AJsonRpcResponse {}

final class SendStreamingMessageSuccessResponse extends A2AJsonRpcResponse {}

final class GetTaskSuccessResponseR extends A2AJsonRpcResponse {}

final class CancelTaskSuccessResponseR extends A2AJsonRpcResponse {}

final class SetTaskPushNotificationConfigSuccessResponse
    extends A2AJsonRpcResponse {}

final class GetTaskPushNotificationConfigSuccessResponseR
    extends A2AJsonRpcResponse {}
