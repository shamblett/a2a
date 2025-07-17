/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// A2A supported error types
class A2AError {
  static const jsonRpc = 0;
  static const jsonParse = -32700;
  static const invalidRequest = -32600;
  static const methodNotFound = -32601;
  static const invalidParams = -32602;
  static const internal = -32603;
  static const taskNotFound = -32001;
  static const taskNotCancellable = -32002;
  static const pushNotificationNotSupported = -32003;
  static const unsupportedOperation = -32004;
  static const contentTypeNotSupported = -32005;
  static const invalidAgentResponse = -32006;

  A2AError();

  factory A2AError.fromJson(Map<String, dynamic> json) => A2AError();

  Map<String, dynamic> toJson() => {};
}

/// Represents a JSON-RPC 2.0 Error object.
/// This is typically included in a JSONRPCErrorResponse when an error occurs.
@JsonSerializable(explicitToJson: true)
final class A2AJSONRPCError extends A2AError {
  /// A Number that indicates the error type that occurred.
  int code = A2AError.jsonRpc;

  /// A Primitive or Structured value that contains additional information about the error.
  /// This may be omitted.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';

  A2AJSONRPCError();

  factory A2AJSONRPCError.fromJson(Map<String, dynamic> json) =>
      _$A2AJSONRPCErrorFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AJSONRPCErrorToJson(this);
}

/// JSON-RPC error indicating invalid JSON was received by the server.
@JsonSerializable(explicitToJson: true)
final class A2AJSONParseError extends A2AError {
  int code = A2AError.jsonParse;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';

  A2AJSONParseError();

  factory A2AJSONParseError.fromJson(Map<String, dynamic> json) =>
      _$A2AJSONParseErrorFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AJSONParseErrorToJson(this);
}

/// JSON-RPC error indicating invalid JSON was received by the server.
@JsonSerializable(explicitToJson: true)
final class A2AInvalidRequestError extends A2AError {
  int code = A2AError.invalidRequest;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';

  A2AInvalidRequestError();

  factory A2AInvalidRequestError.fromJson(Map<String, dynamic> json) =>
      _$A2AInvalidRequestErrorFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AInvalidRequestErrorToJson(this);
}

/// JSON-RPC error indicating invalid JSON was received by the server.
@JsonSerializable(explicitToJson: true)
final class A2AMethodNotFoundError extends A2AError {
  int code = A2AError.methodNotFound;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';

  A2AMethodNotFoundError();

  factory A2AMethodNotFoundError.fromJson(Map<String, dynamic> json) =>
      _$A2AMethodNotFoundErrorFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AMethodNotFoundErrorToJson(this);
}

/// JSON-RPC error indicating invalid JSON was received by the server.
@JsonSerializable(explicitToJson: true)
final class A2AInvalidParamsError extends A2AError {
  int code = A2AError.invalidParams;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';

  A2AInvalidParamsError();

  factory A2AInvalidParamsError.fromJson(Map<String, dynamic> json) =>
      _$A2AInvalidParamsErrorFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AInvalidParamsErrorToJson(this);
}

/// JSON-RPC error indicating invalid JSON was received by the server.
@JsonSerializable(explicitToJson: true)
final class A2AInternalError extends A2AError {
  int code = A2AError.internal;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';

  A2AInternalError();

  factory A2AInternalError.fromJson(Map<String, dynamic> json) =>
      _$A2AInternalErrorFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AInternalErrorToJson(this);
}

/// JSON-RPC error indicating invalid JSON was received by the server.
@JsonSerializable(explicitToJson: true)
final class A2ATaskNotFoundError extends A2AError {
  int code = A2AError.taskNotFound;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';

  A2ATaskNotFoundError();

  factory A2ATaskNotFoundError.fromJson(Map<String, dynamic> json) =>
      _$A2ATaskNotFoundErrorFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2ATaskNotFoundErrorToJson(this);
}

/// JSON-RPC error indicating invalid JSON was received by the server.
@JsonSerializable(explicitToJson: true)
final class A2ATaskNotCancelableError extends A2AError {
  int code = A2AError.taskNotCancellable;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';

  A2ATaskNotCancelableError();

  factory A2ATaskNotCancelableError.fromJson(Map<String, dynamic> json) =>
      _$A2ATaskNotCancelableErrorFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2ATaskNotCancelableErrorToJson(this);
}

/// JSON-RPC error indicating invalid JSON was received by the server.
@JsonSerializable(explicitToJson: true)
final class A2APushNotificationNotSupportedError extends A2AError {
  int code = A2AError.pushNotificationNotSupported;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';

  A2APushNotificationNotSupportedError();

  factory A2APushNotificationNotSupportedError.fromJson(
    Map<String, dynamic> json,
  ) => _$A2APushNotificationNotSupportedErrorFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$A2APushNotificationNotSupportedErrorToJson(this);
}

/// JSON-RPC error indicating invalid JSON was received by the server.
@JsonSerializable(explicitToJson: true)
final class A2AUnsupportedOperationError extends A2AError {
  int code = A2AError.unsupportedOperation;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';

  A2AUnsupportedOperationError();

  factory A2AUnsupportedOperationError.fromJson(Map<String, dynamic> json) =>
      _$A2AUnsupportedOperationErrorFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AUnsupportedOperationErrorToJson(this);
}

/// JSON-RPC error indicating invalid JSON was received by the server.
@JsonSerializable(explicitToJson: true)
final class A2AContentTypeNotSupportedError extends A2AError {
  int code = A2AError.contentTypeNotSupported;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';

  A2AContentTypeNotSupportedError();

  factory A2AContentTypeNotSupportedError.fromJson(Map<String, dynamic> json) =>
      _$A2AContentTypeNotSupportedErrorFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$A2AContentTypeNotSupportedErrorToJson(this);
}

/// JSON-RPC error indicating invalid JSON was received by the server.
@JsonSerializable(explicitToJson: true)
final class A2AInvalidAgentResponseError extends A2AError {
  int code = A2AError.invalidAgentResponse;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';

  A2AInvalidAgentResponseError();

  factory A2AInvalidAgentResponseError.fromJson(Map<String, dynamic> json) =>
      _$A2AInvalidAgentResponseErrorFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AInvalidAgentResponseErrorToJson(this);
}
