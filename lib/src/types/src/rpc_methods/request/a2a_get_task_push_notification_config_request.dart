/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 30/06/2026
* Copyright :  S.Hamblett
*/

part of '../../../a2a_types.dart';

/// JSON-RPC request model for the 'tasks/pushNotificationConfig/get' method.
@JsonSerializable(explicitToJson: true)
final class A2AGetTaskPushNotificationConfigRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  @JsonKey(includeToJson: true, includeFromJson: false)
  String jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  @JsonKey(includeToJson: true, includeFromJson: false)
  String method = A2ARequest.tasksPncGet;

  A2AGetTaskPushNotificationConfigParams? params;

  A2AGetTaskPushNotificationConfigRequest();

  factory A2AGetTaskPushNotificationConfigRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$A2AGetTaskPushNotificationConfigRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$A2AGetTaskPushNotificationConfigRequestToJson(this);
}

/// Defines parameters for fetching a specific push notification configuration for a task.
@JsonSerializable(explicitToJson: true)
class A2AGetTaskPushNotificationConfigParams extends A2ATaskIdParams {
  /// The ID of the push notification configuration to retrieve.
  String? pushNotificationConfigId;

  A2AGetTaskPushNotificationConfigParams();

  factory A2AGetTaskPushNotificationConfigParams.fromJson(
    Map<String, dynamic> json,
  ) => _$A2AGetTaskPushNotificationConfigParamsFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$A2AGetTaskPushNotificationConfigParamsToJson(this);
}
