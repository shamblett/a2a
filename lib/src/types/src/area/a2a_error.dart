/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// A2A supported error types
base class A2AError {}

final class JSONRPCError extends A2AError {}

/// JSON-RPC error indicating invalid JSON was received by the server.
final class JSONParseError extends A2AError {
  final code = -32700;

  /// A Primitive or Structured value that contains additional information about the error.
  late SV data;

  /// A String providing a short description of the error.
  String message = '';
}

final class InvalidRequestError extends A2AError {
  final code = -32600;

  /// A Primitive or Structured value that contains additional information about the error.
  late SV data;

  /// A String providing a short description of the error.
  String message = '';
}

final class MethodNotFoundError extends A2AError {
  final code = -32601;

  /// A Primitive or Structured value that contains additional information about the error.
  late SV data;

  /// A String providing a short description of the error.
  String message = '';
}

final class InvalidParamsError extends A2AError {
  final code = -32602;

  /// A Primitive or Structured value that contains additional information about the error.
  late SV data;

  /// A String providing a short description of the error.
  String message = '';
}

final class InternalError extends A2AError {
  final code = -32603;

  /// A Primitive or Structured value that contains additional information about the error.
  late SV data;

  /// A String providing a short description of the error.
  String message = '';
}

final class TaskNotFoundError extends A2AError {
  final code = -32001;

  /// A Primitive or Structured value that contains additional information about the error.
  late SV data;

  /// A String providing a short description of the error.
  String message = '';
}

final class TaskNotCancelableError extends A2AError {
  final code = -32002;

  /// A Primitive or Structured value that contains additional information about the error.
  late SV data;

  /// A String providing a short description of the error.
  String message = '';
}

final class PushNotificationNotSupportedError extends A2AError {
  final code = -32003;

  /// A Primitive or Structured value that contains additional information about the error.
  late SV data;

  /// A String providing a short description of the error.
  String message = '';
}

final class UnsupportedOperationError extends A2AError {
  final code = -32004;

  /// A Primitive or Structured value that contains additional information about the error.
  late SV data;

  /// A String providing a short description of the error.
  String message = '';
}

final class ContentTypeNotSupportedError extends A2AError {
  final code = -32005;

  /// A Primitive or Structured value that contains additional information about the error.
  late SV data;

  /// A String providing a short description of the error.
  String message = '';
}

final class InvalidAgentResponseError extends A2AError {
  final code = -32006;

  /// A Primitive or Structured value that contains additional information about the error.
  late SV data;

  /// A String providing a short description of the error.
  String message = '';
}
