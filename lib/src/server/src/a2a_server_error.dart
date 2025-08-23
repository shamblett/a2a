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

  static A2AJSONParseError parseError(
    String message,
    Map<String, dynamic>? data,
  ) => A2AJSONParseError()
    ..data = data
    ..message = message;

  static A2AInvalidRequestError invalidRequest(
    String message,
    Map<String, dynamic>? data,
  ) => A2AInvalidRequestError()
    ..message = message
    ..data = data;

  static A2AMethodNotFoundError methodNotFound(String method) =>
      A2AMethodNotFoundError()..message = 'Method not found: $method';

  static A2AInvalidParamsError invalidParams(
    String message,
    Map<String, dynamic>? data,
  ) => A2AInvalidParamsError()
    ..message = message
    ..data = data;

  static A2AInternalError internalError(
    String message,
    Map<String, dynamic>? data,
  ) => A2AInternalError()
    ..message = message
    ..data = data;

  static A2ATaskNotFoundError taskNotFound(String taskId) =>
      A2ATaskNotFoundError()
        ..message = 'Task not found: $taskId'
        ..data = {}
        ..data!['taskId'] = taskId;

  static A2ATaskNotCancelableError taskNotCancelable(String taskId) =>
      A2ATaskNotCancelableError()
        ..message = 'Task not cancelable: $taskId'
        ..data = {}
        ..data!['taskId'] = taskId;

  static A2APushNotificationNotSupportedError pushNotificationNotSupported() =>
      A2APushNotificationNotSupportedError()
        ..message = 'Push Notification is not supported';

  static A2AUnsupportedOperationError unsupportedOperation(String operation) =>
      A2AUnsupportedOperationError()
        ..message = 'Unsupported operation: $operation';

  static A2AAuthenticatedExtendedCardNotConfiguredError
  authenticatedExtendedCardNotConfigured() =>
      A2AAuthenticatedExtendedCardNotConfiguredError()
        ..message = 'Extended card not configured.';

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
