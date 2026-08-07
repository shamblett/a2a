/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 30/06/2026
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// Defines the configuration for setting up push notifications for task updates.
@JsonSerializable(explicitToJson: true)
class A2APushNotificationConfig {
  /// A unique identifier (e.g. UUID) for the push notification configuration, set by the client
  /// to support multiple notification callbacks.
  String? id;

  /// The callback URL where the agent should send push notifications.
  String url = '';

  /// A unique token for this task or session to validate incoming push notifications.
  String? token;

  /// Optional authentication details for the agent to use when calling the notification URL.
  A2APushNotificationAuthenticationInfo? authentication;

  @override
  int get hashCode => id.hashCode;

  A2APushNotificationConfig();

  factory A2APushNotificationConfig.fromJson(Map<String, dynamic> json) =>
      _$A2APushNotificationConfigFromJson(json);

  Map<String, dynamic> toJson() => _$A2APushNotificationConfigToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is A2APushNotificationConfig &&
          runtimeType == other.runtimeType &&
          id == other.id;
}

/// Defines authentication details for a push notification endpoint.
@JsonSerializable(explicitToJson: true)
class A2APushNotificationAuthenticationInfo {
  /// A list of supported authentication schemes (e.g., 'Basic', 'Bearer').
  List<String> schemes = [];

  /// Optional credentials required by the push notification endpoint.
  String? credentials;

  A2APushNotificationAuthenticationInfo();

  factory A2APushNotificationAuthenticationInfo.fromJson(
    Map<String, dynamic> json,
  ) => _$A2APushNotificationAuthenticationInfoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$A2APushNotificationAuthenticationInfoToJson(this);
}

/// A container associating a push notification configuration with a specific task.
@JsonSerializable(explicitToJson: true)
class A2ATaskPushNotificationConfig {
  /// The unique identifier (e.g. UUID) of the task.
  String taskId = '';

  ///  The push notification configuration for this task.
  A2APushNotificationConfig? pushNotificationConfig;
  A2ATaskPushNotificationConfig();

  factory A2ATaskPushNotificationConfig.fromJson(Map<String, dynamic> json) =>
      _$A2ATaskPushNotificationConfigFromJson(json);

  Map<String, dynamic> toJson() => _$A2ATaskPushNotificationConfigToJson(this);
}
