/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 30/06/2026
* Copyright :  S.Hamblett
*/

part of '../../../a2a_types.dart';

/// Represents a JSON-RPC request for the `tasks/pushNotificationConfig/delete` method.
@JsonSerializable(explicitToJson: true)
final class A2ADeleteTaskPushNotificationConfigRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  @JsonKey(includeToJson: true, includeFromJson: false)
  String jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  @JsonKey(includeToJson: true, includeFromJson: false)
  String method = A2ARequest.tasksPncDelete;

  A2ADeleteTaskPushNotificationConfigParams? params;

  A2ADeleteTaskPushNotificationConfigRequest();

  factory A2ADeleteTaskPushNotificationConfigRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$A2ADeleteTaskPushNotificationConfigRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$A2ADeleteTaskPushNotificationConfigRequestToJson(this);
}

/// The parameters identifying the push notification configuration to delete.
@JsonSerializable(explicitToJson: true)
class A2ADeleteTaskPushNotificationConfigParams extends A2ATaskIdParams {
  /// The ID of the push notification configuration to delete.
  String pushNotificationConfigId = '';

  A2ADeleteTaskPushNotificationConfigParams();

  factory A2ADeleteTaskPushNotificationConfigParams.fromJson(
    Map<String, dynamic> json,
  ) => _$A2ADeleteTaskPushNotificationConfigParamsFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$A2ADeleteTaskPushNotificationConfigParamsToJson(this);
}
