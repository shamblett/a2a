/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// Represents a JSON-RPC 2.0 Response object.
sealed class A2AJsonRpcResponse {}

final class A2AJSONRPCErrorResponseR extends A2AJsonRpcResponse
    with A2AJSONRPCErrorResponseM {}

final class A2ASendMessageSuccessResponse extends A2AJsonRpcResponse {}

final class A2ASendStreamingMessageSuccessResponse extends A2AJsonRpcResponse {}

final class A2AGetTaskSuccessResponseR extends A2AJsonRpcResponse {}

final class A2ACancelTaskSuccessResponseR extends A2AJsonRpcResponse {}

final class A2ASetTaskPushNotificationConfigSuccessResponse
    extends A2AJsonRpcResponse {}

final class A2AGetTaskPushNotificationConfigSuccessResponseR
    extends A2AJsonRpcResponse {}
