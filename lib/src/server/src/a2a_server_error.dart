/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../a2a_server.dart';

/// Custom error class for A2A server operations, incorporating JSON-RPC error codes.
class A2AServerError {
  num code = 0;

  Map<String, dynamic>? data;

  String? taskId;

  String? message;

  A2AServerError(this.code, this.message, this.data, this.taskId);

  factory A2AServerError.parseError(
    String message,
    Map<String, dynamic>? data,
  ) => A2AServerError(A2AError.jsonParse, message, data, null);

  factory A2AServerError.invalidRequest(
    String message,
    Map<String, dynamic>? data,
  ) => A2AServerError(A2AError.invalidRequest, message, data, null);

  factory A2AServerError.methodNotFound(String method) => A2AServerError(
    A2AError.invalidRequest,
    'Method not found: $method',
    null,
    null,
  );

  factory A2AServerError.invalidParams(
    String message,
    Map<String, dynamic>? data,
  ) => A2AServerError(A2AError.invalidParams, message, data, null);

  factory A2AServerError.internalError(
    String message,
    Map<String, dynamic>? data,
  ) => A2AServerError(A2AError.internal, message, data, null);

  factory A2AServerError.taskNotFound(String taskId) => A2AServerError(
    A2AError.taskNotFound,
    'Task not found: $taskId',
    null,
    taskId,
  );

  factory A2AServerError.taskNotCancelable(String taskId) => A2AServerError(
    A2AError.taskNotCancellable,
    'Task not cancelable: $taskId',
    null,
    taskId,
  );

  factory A2AServerError.pushNotificationNotSupported() => A2AServerError(
    A2AError.pushNotificationNotSupported,
    'Push Notification is not supported',
    null,
    null,
  );

  factory A2AServerError.unsupportedOperation(String operation) =>
      A2AServerError(
        A2AError.unsupportedOperation,
        'Unsupported operation: $operation',
        null,
        null,
      );

  /// Formats the error into a standard JSON-RPC error object structure.
  A2AJSONRPCError toJSONRPCError() {
    final error = A2AJSONRPCError();
    error.code = code.toInt();
    if (message != null) {
      error.message = message!;
    }
    if (data != null) {
      error.data = data;
    }

    return error;
  }
}
