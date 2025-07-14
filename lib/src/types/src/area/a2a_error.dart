/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// A2A supported error types
base class A2AError {}

final class A2AJSONRPCError extends A2AError {
  /// A Number that indicates the error type that occurred.
  num code = 0;

  /// A Primitive or Structured value that contains additional information about the error.
  /// This may be omitted.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';
}

/// JSON-RPC error indicating invalid JSON was received by the server.
final class A2AJSONParseError extends A2AError {
  final code = -32700;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';
}

final class A2AInvalidRequestError extends A2AError {
  final code = -32600;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';
}

final class A2AMethodNotFoundError extends A2AError {
  final code = -32601;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';
}

final class A2AInvalidParamsError extends A2AError {
  final code = -32602;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';
}

final class A2AInternalError extends A2AError {
  final code = -32603;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';
}

final class A2ATaskNotFoundError extends A2AError {
  final code = -32001;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';
}

final class A2ATaskNotCancelableError extends A2AError {
  final code = -32002;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';
}

final class A2APushNotificationNotSupportedError extends A2AError {
  final code = -32003;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';
}

final class A2AUnsupportedOperationError extends A2AError {
  final code = -32004;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';
}

final class A2AContentTypeNotSupportedError extends A2AError {
  final code = -32005;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';
}

final class A2AInvalidAgentResponseError extends A2AError {
  final code = -32006;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';
}
