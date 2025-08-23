/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// JSON-RPC response for the 'tasks/pushNotificationConfig/delete' method.
class A2ADeleteTaskPushNotificationConfigResponse {
  /// True if the response is an error
  @JsonKey(includeFromJson: false)
  bool isError = false;

  A2ADeleteTaskPushNotificationConfigResponse();

  factory A2ADeleteTaskPushNotificationConfigResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return json.containsKey('result')
          ? A2ADeleteTaskPushNotificationConfigSuccessResponse.fromJson(
              json,
            )
          : A2AJSONRPCErrorResponseDTPR.fromJson(json)
      ..isError = true;
  }

  Map<String, dynamic> toJson() => {};
}

/// /// JSON RPC error response object
@JsonSerializable(explicitToJson: true)
final class A2AJSONRPCErrorResponseDTPR
    extends A2ADeleteTaskPushNotificationConfigResponse
    with A2AJSONRPCErrorResponseM {
  A2AJSONRPCErrorResponseDTPR();

  factory A2AJSONRPCErrorResponseDTPR.fromJson(Map<String, dynamic> json) =>
      _$A2AJSONRPCErrorResponseDTPRFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AJSONRPCErrorResponseDTPRToJson(this);
}

/// JSON-RPC success response model for the 'tasks/pushNotificationConfig/set' method.
@JsonSerializable(explicitToJson: true)
final class A2ADeleteTaskPushNotificationConfigSuccessResponse
    extends A2ADeleteTaskPushNotificationConfigResponse {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  @JsonKey(includeToJson: true, includeFromJson: false)
  String jsonrpc = '2.0';

  Object? result;

  A2ADeleteTaskPushNotificationConfigSuccessResponse();

  factory A2ADeleteTaskPushNotificationConfigSuccessResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$A2ADeleteTaskPushNotificationConfigSuccessResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$A2ADeleteTaskPushNotificationConfigSuccessResponseToJson(this);
}
