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
  static const unknown = -1;

  /// The error code as received from the RPC call.
  /// Can be used to ascertain the type of the error received to allow
  /// correct type casting.
  @JsonKey(includeFromJson: false)
  int rpcErrorCode = unknown;

  A2AError();

  factory A2AError.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('code')) {
      return A2AError();
    } else {
      switch (json['code']) {
        case jsonRpc:
          return A2AJSONRPCError.fromJson(json)..rpcErrorCode = jsonRpc;
        case jsonParse:
          return A2AJSONParseError.fromJson(json)..rpcErrorCode = jsonParse;
        case invalidRequest:
          return A2AInvalidRequestError.fromJson(json)
            ..rpcErrorCode = invalidRequest;
        case methodNotFound:
          return A2AMethodNotFoundError.fromJson(json)
            ..rpcErrorCode = methodNotFound;
        case invalidParams:
          return A2AInvalidParamsError.fromJson(json)
            ..rpcErrorCode = invalidParams;
        case internal:
          return A2AInternalError.fromJson(json)..rpcErrorCode = internal;
        case taskNotFound:
          return A2ATaskNotFoundError.fromJson(json)
            ..rpcErrorCode = taskNotFound;
        case taskNotCancellable:
          return A2ATaskNotCancelableError.fromJson(json)
            ..rpcErrorCode = taskNotCancellable;
        case pushNotificationNotSupported:
          return A2APushNotificationNotSupportedError.fromJson(json)
            ..rpcErrorCode = pushNotificationNotSupported;
        case unsupportedOperation:
          return A2AUnsupportedOperationError.fromJson(json)
            ..rpcErrorCode = unsupportedOperation;
        case contentTypeNotSupported:
          return A2AContentTypeNotSupportedError.fromJson(json)
            ..rpcErrorCode = contentTypeNotSupported;
        case invalidAgentResponse:
          return A2AInvalidAgentResponseError.fromJson(json)
            ..rpcErrorCode = invalidAgentResponse;
        default:
          return A2AError();
      }
    }
  }

  Map<String, dynamic> toJson() {
    if (this is A2AJSONRPCError) {
      return (this as A2AJSONRPCError).toJson();
    }
    if (this is A2AJSONParseError) {
      return (this as A2AJSONParseError).toJson();
    }
    if (this is A2AInvalidRequestError) {
      return (this as A2AInvalidRequestError).toJson();
    }
    if (this is A2AMethodNotFoundError) {
      return (this as A2AMethodNotFoundError).toJson();
    }
    if (this is A2AInvalidParamsError) {
      return (this as A2AInvalidParamsError).toJson();
    }
    if (this is A2AInternalError) {
      return (this as A2AInternalError).toJson();
    }
    if (this is A2ATaskNotFoundError) {
      return (this as A2ATaskNotFoundError).toJson();
    }
    if (this is A2ATaskNotCancelableError) {
      return (this as A2ATaskNotCancelableError).toJson();
    }
    if (this is A2APushNotificationNotSupportedError) {
      return (this as A2APushNotificationNotSupportedError).toJson();
    }
    if (this is A2AUnsupportedOperationError) {
      return (this as A2AUnsupportedOperationError).toJson();
    }
    if (this is A2AContentTypeNotSupportedError) {
      return (this as A2AContentTypeNotSupportedError).toJson();
    }
    if (this is A2AInvalidAgentResponseError) {
      return (this as A2AInvalidAgentResponseError).toJson();
    }
    return {};
  }

  /// Convert the RPC code to a string
  static String asString(int code) {
    switch (code) {
      case jsonRpc:
        return 'JSON RPC';
      case jsonParse:
        return 'JSON Parse';
      case invalidRequest:
        return 'Invalid Request';
      case methodNotFound:
        return 'Method Not Found';
      case invalidParams:
        return 'Invalid Parameters';
      case internal:
        return 'Internal Server Error';
      case taskNotFound:
        return 'Task Not Found';
      case taskNotCancellable:
        return 'Task Not Cancellable';
      case pushNotificationNotSupported:
        return 'Push Notification Not Supported';
      case unsupportedOperation:
        return 'Unsupported Operation';
      case contentTypeNotSupported:
        return 'Content Type Not Supported';
      case invalidAgentResponse:
        return 'Invalid Agent Response';
      default:
        return 'Unknown Error Code';
    }
  }
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
  /// In this case 'taskId' will contain the Task Id
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
  /// In this case 'taskId' will contain the Task Id
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
