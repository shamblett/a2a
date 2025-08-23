/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// JSON-RPC response for the 'tasks/pushNotificationConfig/list' method.
class A2AListTaskPushNotificationConfigResponse {
  /// True if the response is an error
  @JsonKey(includeFromJson: false)
  bool isError = false;

  A2AListTaskPushNotificationConfigResponse();

  factory A2AListTaskPushNotificationConfigResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    if (json.containsKey('error')) {
      final response = A2AJSONRPCErrorResponseLTPR.fromJson(json);
      response.isError = true;
      return response;
    } else {
      return A2AListTaskPushNotificationConfigSuccessResponse.fromJson((json));
    }
  }

  Map<String, dynamic> toJson() => {};
}

/// Represents a JSON-RPC 2.0 Error Response object.
@JsonSerializable(explicitToJson: true)
final class A2AJSONRPCErrorResponseLTPR
    extends A2AListTaskPushNotificationConfigResponse
    with A2AJSONRPCErrorResponseM {
  A2AJSONRPCErrorResponseLTPR();

  factory A2AJSONRPCErrorResponseLTPR.fromJson(Map<String, dynamic> json) =>
      _$A2AJSONRPCErrorResponseLTPRFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AJSONRPCErrorResponseLTPRToJson(this);
}

/// JSON-RPC success response model for the 'tasks/pushNotificationConfig/list' method.
@JsonSerializable(explicitToJson: true)
final class A2AListTaskPushNotificationConfigSuccessResponse
    extends A2AListTaskPushNotificationConfigResponse {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  @JsonKey(includeToJson: true, includeFromJson: false)
  String jsonrpc = '2.0';
  List<A2APushNotificationConfig>? result;

  A2AListTaskPushNotificationConfigSuccessResponse();

  factory A2AListTaskPushNotificationConfigSuccessResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$A2AListTaskPushNotificationConfigSuccessResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$A2AListTaskPushNotificationConfigSuccessResponseToJson(this);
}
