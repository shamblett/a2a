/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../a2a_types.dart';

/// A2A supported error types
class A2AError {
  /// Standard JSON_RPC errors.

  /// No error.
  static const jsonRpc = 0;

  /// Server received JSON that was not well-formed.
  static const jsonParse = -32700;

  /// The JSON payload was valid JSON, but not a valid JSON-RPC Request object.
  static const invalidRequest = -32600;

  /// The requested A2A RPC method (e.g., "tasks/foo") does not exist or is not supported.
  static const methodNotFound = -32601;

  /// The params provided for the method are invalid (e.g., wrong type, missing required field).
  static const invalidParams = -32602;

  /// An unexpected error occurred on the server during processing.
  static const internal = -32603;

  /// Reserved for implementation-defined server-errors. A2A-specific errors use this range.

  /// The specified task id does not correspond to an existing or active task. I
  /// t might be invalid, expired, or already completed and purged.
  static const taskNotFound = -32001;

  /// An attempt was made to cancel a task that is not in a cancelable state (e.g., it has already reached a
  /// terminal state like completed, failed, or canceled).
  static const taskNotCancellable = -32002;

  /// Client attempted to use push notification features (e.g., tasks/pushNotificationConfig/set) but the server agent does not
  /// support them (i.e., AgentCard.capabilities.pushNotifications is false).
  static const pushNotificationNotSupported = -32003;

  /// The requested operation or a specific aspect of it (perhaps implied by parameters) is not supported by this server agent implementation.
  /// Broader than just method not found.
  static const unsupportedOperation = -32004;

  /// An Media Type provided in the request's message.parts (or implied for an artifact) is not
  /// supported by the agent or the specific skill being invoked.
  static const contentTypeNotSupported = -32005;

  /// Agent generated an invalid response for the requested method
  static const invalidAgentResponse = -32006;

  /// The agent does not have an Authenticated Extended Card configured.
  static const authenticatedExtendedCardNotConfigured = -32007;

  /// Unknown error
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
        case authenticatedExtendedCardNotConfigured:
          return A2AAuthenticatedExtendedCardNotConfiguredError.fromJson(json)
            ..rpcErrorCode = authenticatedExtendedCardNotConfigured;
        default:
          return A2AError()..rpcErrorCode = json['code'];
      }
    }
  }

  Map<String, dynamic> toJson() => {};

  /// Convert the RPC code to a string
  static String asString(int code) {
    switch (code) {
      case jsonRpc:
        return 'No Error';
      case jsonParse:
        return 'Invalid JSON payload';
      case invalidRequest:
        return 'Invalid JSON-RPC Request';
      case methodNotFound:
        return 'Method not found';
      case invalidParams:
        return 'Invalid method parameters';
      case internal:
        return 'Internal server error';
      case taskNotFound:
        return 'Task Not Found';
      case taskNotCancellable:
        return 'Task cannot be canceled';
      case pushNotificationNotSupported:
        return 'Push Notification is not supported';
      case unsupportedOperation:
        return 'This operation is not supported';
      case contentTypeNotSupported:
        return 'Incompatible content types';
      case invalidAgentResponse:
        return 'Invalid agent response type';
      case authenticatedExtendedCardNotConfigured:
        return 'Authenticated Extended Card not configured';
      default:
        return 'Unknown Error Code';
    }
  }
}

/// JSON-RPC error indicating invalid JSON was received by the server.
@JsonSerializable(explicitToJson: true)
final class A2AJSONParseError extends A2AError {
  /// A Number that indicates the error type that occurred.
  @JsonKey(includeToJson: true, includeFromJson: false)
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
  /// A Number that indicates the error type that occurred.
  @JsonKey(includeToJson: true, includeFromJson: false)
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
  /// A Number that indicates the error type that occurred.
  @JsonKey(includeToJson: true, includeFromJson: false)
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
  /// A Number that indicates the error type that occurred.
  @JsonKey(includeToJson: true, includeFromJson: false)
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
  /// A Number that indicates the error type that occurred.
  @JsonKey(includeToJson: true, includeFromJson: false)
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
  /// A Number that indicates the error type that occurred.
  @JsonKey(includeToJson: true, includeFromJson: false)
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
  /// A Number that indicates the error type that occurred.
  @JsonKey(includeToJson: true, includeFromJson: false)
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
  /// A Number that indicates the error type that occurred.
  @JsonKey(includeToJson: true, includeFromJson: false)
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
  /// A Number that indicates the error type that occurred.
  @JsonKey(includeToJson: true, includeFromJson: false)
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
  /// A Number that indicates the error type that occurred.
  @JsonKey(includeToJson: true, includeFromJson: false)
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
  /// A Number that indicates the error type that occurred.
  @JsonKey(includeToJson: true, includeFromJson: false)
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

/// JSON-RPC error indicating no authenticated agen card has been configured.
@JsonSerializable(explicitToJson: true)
final class A2AAuthenticatedExtendedCardNotConfiguredError extends A2AError {
  /// A Number that indicates the error type that occurred.
  @JsonKey(includeToJson: true, includeFromJson: false)
  int code = A2AError.authenticatedExtendedCardNotConfigured;

  /// A Primitive or Structured value that contains additional information about the error.
  A2ASV? data;

  /// A String providing a short description of the error.
  String message = '';

  A2AAuthenticatedExtendedCardNotConfiguredError();

  factory A2AAuthenticatedExtendedCardNotConfiguredError.fromJson(
    Map<String, dynamic> json,
  ) => _$A2AAuthenticatedExtendedCardNotConfiguredErrorFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$A2AAuthenticatedExtendedCardNotConfiguredErrorToJson(this);
}
