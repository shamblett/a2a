// ignore_for_file: no-equal-then-else

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
  @JsonKey(includeFromJson: false)
  bool isError = false;

  A2AJsonRpcResponse();

  factory A2AJsonRpcResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('result')) {
      // Not an error
      if ((json['result'] as Map).containsKey('kind')) {
        // Check which message response it is
        return json['result']['kind'] == 'artifact-update' ||
                json['result']['kind'] == 'status-update'
            ? A2ASendStreamingMessageSuccessResponse().fromJson(json)
            : A2ASendMessageSuccessResponse().fromJson(json);
      }
      // Check for Push notification
      return (json['result'] as Map).containsKey('token')
          ? A2ASetTaskPushNotificationConfigSuccessResponse().fromJson(json)
          : A2ASendMessageSuccessResponse().fromJson(json);
    } else {
      // Error, doesn't matter which response we pick
      return A2AJSONRPCErrorResponseS.fromJson(json)..isError = true;
    }
  }

  Map<String, dynamic> toJson() {
    if (this is A2ASendMessageSuccessResponse) {
      return (this as A2ASendMessageSuccessResponse).toJson();
    }
    if (this is A2ASendStreamingMessageSuccessResponse) {
      return (this as A2ASendStreamingMessageSuccessResponse).toJson();
    }
    if (this is A2ASetTaskPushNotificationConfigSuccessResponse) {
      return (this as A2ASetTaskPushNotificationConfigSuccessResponse).toJson();
    }
    return {};
  }
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
      return A2ASendMessageSuccessResponse().fromJson((json));
    }
  }

  @override
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
      final response = A2AJSONRPCErrorResponseS.fromJson(json);
      response.isError = true;
      return response as A2AJSONRPCErrorResponseSS;
    } else {
      return A2ASendStreamingMessageSuccessResponse().fromJson((json));
    }
  }

  @override
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
      final response = A2AJSONRPCErrorResponseS.fromJson(json);
      response.isError = true;
      return response as A2AJSONRPCErrorResponsePNCR;
    } else {
      return A2ASetTaskPushNotificationConfigSuccessResponse().fromJson((json));
    }
  }

  @override
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
  String jsonrpc = '2.0';

  /// The result object on success, [A2ATask] or [A2AMessage]
  A2AResult? result;

  A2ASendMessageSuccessResponse();

  A2ASendMessageSuccessResponse fromJson(Map<String, dynamic> json) {
    // Decode the result
    final response = _$A2ASendMessageSuccessResponseFromJson(json);
    if (json.containsKey('result')) {
      if (json['result']['kind'] == 'task') {
        response.result = _$A2ATaskFromJson(json['result']);
        return response;
      }
      if (json['result']['kind'] == 'message') {
        response.result = _$A2AMessageFromJson(json['result']);
        return response;
      }
    }

    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final json = _$A2ASendMessageSuccessResponseToJson(this);
    if (result != null) {
      if (result is A2ATask) {
        json['result'] = _$A2ATaskToJson(result as A2ATask);
        return json;
      }
      if (result is A2AMessage) {
        json['result'] = _$A2AMessageToJson(result as A2AMessage);
        return json;
      }
    }
    return json;
  }
}

/// JSON-RPC success response model for the 'message/stream' method.
@JsonSerializable(explicitToJson: true)
final class A2ASendStreamingMessageSuccessResponse
    extends A2ASendStreamingMessageResponse {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  String jsonrpc = '2.0';

  /// The result object on success, [A2ATask], [A2AMessage], [A2ATaskStatusUpdateEvent] or
  /// [A2ATaskArtifactUpdateEvent]
  A2AResult? result;

  A2ASendStreamingMessageSuccessResponse();

  A2ASendStreamingMessageSuccessResponse fromJson(Map<String, dynamic> json) {
    final response = _$A2ASendStreamingMessageSuccessResponseFromJson(json);

    if (json.containsKey('result')) {
      if (json['result']['kind'] == 'task') {
        response.result = _$A2ATaskFromJson(json['result']);
        return response;
      }
      if (json['result']['kind'] == 'message') {
        response.result = _$A2AMessageFromJson(json['result']);
        return response;
      }
      if (json['result']['kind'] == 'status-update') {
        response.result = _$A2ATaskStatusUpdateEventFromJson(json['result']);
        return response;
      }
      if (json['result']['kind'] == 'artifact-update') {
        response.result = _$A2ATaskArtifactUpdateEventFromJson(json['result']);
        return response;
      }
    }

    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final json = _$A2ASendStreamingMessageSuccessResponseToJson(this);
    if (result != null) {
      if (result is A2ATask) {
        json['result'] = _$A2ATaskToJson(result as A2ATask);
        return json;
      }
      if (result is A2AMessage) {
        json['result'] = _$A2AMessageToJson(result as A2AMessage);
        return json;
      }
      if (result is A2ATask) {
        json['result'] = _$A2ATaskToJson(result as A2ATask);
        return json;
      }
      if (result is A2ATaskStatusUpdateEvent) {
        json['result'] = _$A2ATaskStatusUpdateEventToJson(
          result as A2ATaskStatusUpdateEvent,
        );
        return json;
      }
      if (result is A2ATaskArtifactUpdateEvent) {
        json['result'] = _$A2ATaskArtifactUpdateEventToJson(
          result as A2ATaskArtifactUpdateEvent,
        );
        return json;
      }
    }
    return json;
  }
}

/// JSON-RPC success response model for the 'tasks/pushNotificationConfig/set' method.
@JsonSerializable(explicitToJson: true)
final class A2ASetTaskPushNotificationConfigSuccessResponse
    extends SetTaskPushNotificationConfigResponse {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  String jsonrpc = '2.0';
  A2ATaskPushNotificationConfig1? result;

  A2ASetTaskPushNotificationConfigSuccessResponse();

  A2ASetTaskPushNotificationConfigSuccessResponse fromJson(
    Map<String, dynamic> json,
  ) {
    final response = _$A2ASetTaskPushNotificationConfigSuccessResponseFromJson(
      json,
    );

    if (json.containsKey('result')) {
      response.result = _$A2ATaskPushNotificationConfig1FromJson(
        json['result'],
      );
      return response;
    }
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final json = _$A2ASetTaskPushNotificationConfigSuccessResponseToJson(this);
    if (result != null) {
      json['result'] = _$A2ATaskPushNotificationConfig1ToJson(
        result as A2ATaskPushNotificationConfig1,
      );
      return json;
    }

    return json;
  }
}
