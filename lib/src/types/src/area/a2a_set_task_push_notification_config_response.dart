/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// JSON-RPC response for the 'tasks/pushNotificationConfig/set' method.
class A2ASetTaskPushNotificationConfigResponse {
  /// True if the response is an error
  @JsonKey(includeFromJson: false)
  bool isError = false;

  A2ASetTaskPushNotificationConfigResponse();

  factory A2ASetTaskPushNotificationConfigResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return json.containsKey('result')
          ? A2ASetTaskPushNotificationConfigSuccessResponseSTPR.fromJson(json)
          : A2AJSONRPCErrorResponseSTPR.fromJson(json)
      ..isError = true;
  }

  Map<String, dynamic> toJson() => {};
}

/// /// JSON RPC error response object
@JsonSerializable(explicitToJson: true)
final class A2AJSONRPCErrorResponseSTPR
    extends A2ASetTaskPushNotificationConfigResponse
    with A2AJSONRPCErrorResponseM {
  A2AJSONRPCErrorResponseSTPR();

  factory A2AJSONRPCErrorResponseSTPR.fromJson(Map<String, dynamic> json) =>
      _$A2AJSONRPCErrorResponseSTPRFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AJSONRPCErrorResponseSTPRToJson(this);
}

/// JSON-RPC success response model for the 'tasks/pushNotificationConfig/set' method.
@JsonSerializable(explicitToJson: true)
final class A2ASetTaskPushNotificationConfigSuccessResponseSTPR
    extends A2ASetTaskPushNotificationConfigResponse {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  String jsonrpc = '2.0';
  A2ATaskPushNotificationConfig? result;

  A2ASetTaskPushNotificationConfigSuccessResponseSTPR();

  factory A2ASetTaskPushNotificationConfigSuccessResponseSTPR.fromJson(
    Map<String, dynamic> json,
  ) => _$A2ASetTaskPushNotificationConfigSuccessResponseSTPRFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$A2ASetTaskPushNotificationConfigSuccessResponseSTPRToJson(this);
}
