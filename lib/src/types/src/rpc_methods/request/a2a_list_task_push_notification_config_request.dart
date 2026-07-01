/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 30/06/2026
* Copyright :  S.Hamblett
*/

part of '../../../a2a_types.dart';

/// Represents a JSON-RPC request for the `tasks/pushNotificationConfig/list` method.
@JsonSerializable(explicitToJson: true)
final class A2AListTaskPushNotificationConfigRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  @JsonKey(includeToJson: true, includeFromJson: false)
  String jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  @JsonKey(includeToJson: true, includeFromJson: false)
  String method = A2ARequest.tasksPncList;

  A2AListTaskPushNotificationConfigParams? params;

  A2AListTaskPushNotificationConfigRequest();

  factory A2AListTaskPushNotificationConfigRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$A2AListTaskPushNotificationConfigRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$A2AListTaskPushNotificationConfigRequestToJson(this);
}

/// The parameters identifying the task whose configurations are to be listed.
@JsonSerializable(explicitToJson: true)
class A2AListTaskPushNotificationConfigParams extends A2ATaskIdParams {
  A2AListTaskPushNotificationConfigParams();

  factory A2AListTaskPushNotificationConfigParams.fromJson(
    Map<String, dynamic> json,
  ) => _$A2AListTaskPushNotificationConfigParamsFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$A2AListTaskPushNotificationConfigParamsToJson(this);
}
