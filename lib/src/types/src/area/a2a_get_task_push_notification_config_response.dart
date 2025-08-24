/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// JSON-RPC response for the 'tasks/pushNotificationConfig/get' method.
class A2AGetTaskPushNotificationConfigResponse {
  /// True if the response is an error
  @JsonKey(includeFromJson: false)
  bool isError = false;

  A2AGetTaskPushNotificationConfigResponse();

  factory A2AGetTaskPushNotificationConfigResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    if (json.containsKey('error')) {
      final response = A2AJSONRPCErrorResponseGTPR.fromJson(json);
      response.isError = true;
      return response;
    } else {
      return A2AGetTaskPushNotificationConfigSuccessResponse.fromJson((json));
    }
  }

  Map<String, dynamic> toJson() => {};
}

/// Represents a JSON-RPC 2.0 Error Response object.
@JsonSerializable(explicitToJson: true)
final class A2AJSONRPCErrorResponseGTPR
    extends A2AGetTaskPushNotificationConfigResponse
    with A2AJSONRPCErrorResponseM {
  A2AJSONRPCErrorResponseGTPR();

  factory A2AJSONRPCErrorResponseGTPR.fromJson(Map<String, dynamic> json) =>
      _$A2AJSONRPCErrorResponseGTPRFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AJSONRPCErrorResponseGTPRToJson(this);
}

/// JSON-RPC success response model for the 'tasks/pushNotificationConfig/get' method.
@JsonSerializable(explicitToJson: true)
final class A2AGetTaskPushNotificationConfigSuccessResponse
    extends A2AGetTaskPushNotificationConfigResponse {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  @JsonKey(includeToJson: true, includeFromJson: false)
  String jsonrpc = '2.0';
  A2ATaskPushNotificationConfig? result;

  A2AGetTaskPushNotificationConfigSuccessResponse();

  factory A2AGetTaskPushNotificationConfigSuccessResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$A2AGetTaskPushNotificationConfigSuccessResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$A2AGetTaskPushNotificationConfigSuccessResponseToJson(this);
}
