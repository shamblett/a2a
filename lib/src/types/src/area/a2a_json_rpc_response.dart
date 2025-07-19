/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// Represents a JSON-RPC 2.0 Response object.
class A2AJsonRpcResponse {
  /// True if the response is an error
  bool isError = false;
}

/// JSON-RPC response model for the 'message/send' method.
class A2ASendMessageResponse extends A2AJsonRpcResponse {
  A2ASendMessageResponse();

  factory A2ASendMessageResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error')) {
      final response = A2AJSONRPCErrorResponseS.fromJson(json);
      response.isError = true;
      return response;
    } else {
      return A2ASendMessageSuccessResponse.fromJson((json));
    }
  }

  Map<String, dynamic> toJson() {
    if (this is A2AJSONRPCErrorResponseS) {
      return (this as A2AJSONRPCErrorResponseS).toJson();
    }
    if (this is A2ASendMessageSuccessResponse) {
      return (this as A2ASendMessageSuccessResponse).toJson();
    }

    return {};
  }
}

/// JSON-RPC response model for the 'message/stream' method.
class A2ASendStreamingMessageResponse extends A2AJsonRpcResponse {
  A2ASendStreamingMessageResponse();

  factory A2ASendStreamingMessageResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error')) {
      final response = A2AJSONRPCErrorResponseSS.fromJson(json);
      response.isError = true;
      return response;
    } else {
      return A2ASendStreamingMessageSuccessResponse.fromJson((json));
    }
  }

  Map<String, dynamic> toJson() {
    if (this is A2AJSONRPCErrorResponseSS) {
      return (this as A2AJSONRPCErrorResponseSS).toJson();
    }
    if (this is A2ASendStreamingMessageSuccessResponse) {
      return (this as A2ASendStreamingMessageSuccessResponse).toJson();
    }

    return {};
  }
}

/// JSON-RPC response model for the 'tasks/pushNotificationConfig/set' method.
class SetTaskPushNotificationConfigResponse extends A2AJsonRpcResponse {
  SetTaskPushNotificationConfigResponse();

  factory SetTaskPushNotificationConfigResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    if (json.containsKey('error')) {
      final response = A2AJSONRPCErrorResponsePNCR.fromJson(json);
      response.isError = true;
      return response;
    } else {
      return A2ASetTaskPushNotificationConfigSuccessResponse.fromJson((json));
    }
  }

  Map<String, dynamic> toJson() {
    if (this is A2AJSONRPCErrorResponsePNCR) {
      return (this as A2AJSONRPCErrorResponsePNCR).toJson();
    }
    if (this is A2ASetTaskPushNotificationConfigSuccessResponse) {
      return (this as A2ASetTaskPushNotificationConfigSuccessResponse).toJson();
    }

    return {};
  }
}

/// RPC error send
@JsonSerializable(explicitToJson: true)
final class A2AJSONRPCErrorResponseS extends A2ASendMessageResponse
    with A2AJSONRPCErrorResponseM {
  A2AJSONRPCErrorResponseS();

  factory A2AJSONRPCErrorResponseS.fromJson(Map<String, dynamic> json) =>
      _$A2AJSONRPCErrorResponseSFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AJSONRPCErrorResponseSToJson(this);
}

/// RPC error send stream
@JsonSerializable(explicitToJson: true)
final class A2AJSONRPCErrorResponseSS extends A2ASendStreamingMessageResponse
    with A2AJSONRPCErrorResponseM {
  A2AJSONRPCErrorResponseSS();

  factory A2AJSONRPCErrorResponseSS.fromJson(Map<String, dynamic> json) =>
      _$A2AJSONRPCErrorResponseSSFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AJSONRPCErrorResponseSSToJson(this);
}

/// RPC error PN configuration
@JsonSerializable(explicitToJson: true)
final class A2AJSONRPCErrorResponsePNCR
    extends SetTaskPushNotificationConfigResponse
    with A2AJSONRPCErrorResponseM {
  A2AJSONRPCErrorResponsePNCR();

  factory A2AJSONRPCErrorResponsePNCR.fromJson(Map<String, dynamic> json) =>
      _$A2AJSONRPCErrorResponsePNCRFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AJSONRPCErrorResponsePNCRToJson(this);
}

/// JSON-RPC success response model for the 'message/send' method.
@JsonSerializable(explicitToJson: true)
final class A2ASendMessageSuccessResponse extends A2ASendMessageResponse {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';

  /// The result object on success, [A2ATask] or [A2AMessage]
  Object? result;

  A2ASendMessageSuccessResponse();

  factory A2ASendMessageSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$A2ASendMessageSuccessResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2ASendMessageSuccessResponseToJson(this);
}

/// JSON-RPC success response model for the 'message/stream' method.
@JsonSerializable(explicitToJson: true)
final class A2ASendStreamingMessageSuccessResponse
    extends A2ASendStreamingMessageResponse {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';

  /// The result object on success, [A2ATask], [A2AMessage], [A2ATaskStatusUpdateEvent] or
  /// [A2ATaskArtifactUpdateEvent]
  Object? result;

  A2ASendStreamingMessageSuccessResponse();

  factory A2ASendStreamingMessageSuccessResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$A2ASendStreamingMessageSuccessResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$A2ASendStreamingMessageSuccessResponseToJson(this);
}

/// JSON-RPC success response model for the 'tasks/pushNotificationConfig/set' method.
@JsonSerializable(explicitToJson: true)
final class A2ASetTaskPushNotificationConfigSuccessResponse
    extends SetTaskPushNotificationConfigResponse {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';
  A2ATaskPushNotificationConfig1? result;

  A2ASetTaskPushNotificationConfigSuccessResponse();

  factory A2ASetTaskPushNotificationConfigSuccessResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$A2ASetTaskPushNotificationConfigSuccessResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$A2ASetTaskPushNotificationConfigSuccessResponseToJson(this);
}
