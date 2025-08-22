/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// A2A supported request types
class A2ARequest {
  static const messageSend = 'message/send';
  static const messageStream = 'message/stream';
  static const tasksGet = 'tasks/get';
  static const tasksCancel = 'tasks/cancel';
  static const tasksPncSet = 'tasks/pushNotificationConfig/set';
  static const tasksPncGet = 'tasks/pushNotificationConfig/get';
  static const tasksResubscribe = 'tasks/resubscribe';

  /// Set if a valid request cannot be formed by [fromJson].
  @JsonKey(includeFromJson: false)
  bool unknownRequest = false;

  factory A2ARequest.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('method')) {
      return A2ARequest();
    } else {
      switch (json['method']) {
        case messageSend:
          return A2ASendMessageRequest.fromJson(json);
        case messageStream:
          return A2ASendStreamingMessageRequest.fromJson(json);
        case tasksGet:
          return A2AGetTaskRequest.fromJson(json);
        case tasksCancel:
          return A2ACancelTaskRequest.fromJson(json);
        case tasksPncSet:
          return A2ASetTaskPushNotificationConfigRequest.fromJson(json);
        case tasksPncGet:
          return A2AGetTaskPushNotificationConfigRequest.fromJson(json);
        case tasksResubscribe:
          return A2ATaskResubscriptionRequest.fromJson(json);
        default:
          return A2ARequest()..unknownRequest = true;
      }
    }
  }

  A2ARequest();

  Map<String, dynamic> toJson() => {};
}

/// JSON-RPC request model for the 'message/send' method.
@JsonSerializable(explicitToJson: true)
final class A2ASendMessageRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  @JsonKey(includeToJson: true, includeFromJson: false)
  String jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  @JsonKey(includeToJson: true, includeFromJson: false)
  String method = 'message/send';

  A2AMessageSendParams? params;

  A2ASendMessageRequest();

  factory A2ASendMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$A2ASendMessageRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2ASendMessageRequestToJson(this);
}

/// JSON-RPC request model for the 'message/stream' method.
@JsonSerializable(explicitToJson: true)
final class A2ASendStreamingMessageRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  @JsonKey(includeToJson: true, includeFromJson: false)
  String jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  @JsonKey(includeToJson: true, includeFromJson: false)
  String method = 'message/stream';

  A2AMessageSendParams? params;

  A2ASendStreamingMessageRequest();

  factory A2ASendStreamingMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$A2ASendStreamingMessageRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2ASendStreamingMessageRequestToJson(this);
}

/// JSON-RPC request model for the 'tasks/get' method.
@JsonSerializable(explicitToJson: true)
final class A2AGetTaskRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  @JsonKey(includeToJson: true, includeFromJson: false)
  String jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  @JsonKey(includeToJson: true, includeFromJson: false)
  String method = 'tasks/get';

  A2ATaskQueryParams? params;

  A2AGetTaskRequest();

  factory A2AGetTaskRequest.fromJson(Map<String, dynamic> json) =>
      _$A2AGetTaskRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AGetTaskRequestToJson(this);
}

/// JSON-RPC request model for the 'tasks/cancel' method.
@JsonSerializable(explicitToJson: true)
final class A2ACancelTaskRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  @JsonKey(includeToJson: true, includeFromJson: false)
  String jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  @JsonKey(includeToJson: true, includeFromJson: false)
  String method = 'tasks/cancel';

  A2ATaskIdParams? params;

  A2ACancelTaskRequest();

  factory A2ACancelTaskRequest.fromJson(Map<String, dynamic> json) =>
      _$A2ACancelTaskRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2ACancelTaskRequestToJson(this);
}

/// JSON-RPC request model for the 'tasks/pushNotificationConfig/set' method.
@JsonSerializable(explicitToJson: true)
final class A2ASetTaskPushNotificationConfigRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  @JsonKey(includeToJson: true, includeFromJson: false)
  String jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  @JsonKey(includeToJson: true, includeFromJson: false)
  String method = 'tasks/pushNotificationConfig/set';

  A2ATaskPushNotificationConfig? params;

  A2ASetTaskPushNotificationConfigRequest();

  factory A2ASetTaskPushNotificationConfigRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$A2ASetTaskPushNotificationConfigRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$A2ASetTaskPushNotificationConfigRequestToJson(this);
}

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
  String method = 'tasks/pushNotificationConfig/get';

  A2ATaskIdParams? params;

  A2AGetTaskPushNotificationConfigRequest();

  factory A2AGetTaskPushNotificationConfigRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$A2AGetTaskPushNotificationConfigRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$A2AGetTaskPushNotificationConfigRequestToJson(this);
}

/// JSON-RPC request model for the 'tasks/resubscribe' method.
@JsonSerializable(explicitToJson: true)
final class A2ATaskResubscriptionRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  @JsonKey(includeToJson: true, includeFromJson: false)
  String jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  @JsonKey(includeToJson: true, includeFromJson: false)
  String method = 'tasks/resubscribe';

  A2ATaskIdParams? params;

  A2ATaskResubscriptionRequest();

  factory A2ATaskResubscriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$A2ATaskResubscriptionRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2ATaskResubscriptionRequestToJson(this);
}

/// The result object on success.
@JsonSerializable(explicitToJson: true)
class A2ATaskPushNotificationConfig1 {
  A2APushNotificationAuthenticationInfo? authentication;

  /// Push Notification ID - created by server to support multiple callbacks
  String id = '';

  /// Token unique to this task/session.
  String? token;

  /// URL for sending the push notifications.
  String url = '';

  A2ATaskPushNotificationConfig1();

  factory A2ATaskPushNotificationConfig1.fromJson(Map<String, dynamic> json) =>
      _$A2ATaskPushNotificationConfig1FromJson(json);

  Map<String, dynamic> toJson() => _$A2ATaskPushNotificationConfig1ToJson(this);
}

/// A container associating a push notification configuration with a specific task.
@JsonSerializable(explicitToJson: true)
class A2ATaskPushNotificationConfig {
  ///  The push notification configuration for this task.
  A2APushNotificationConfig? pushNotificationConfig;

  /// The unique identifier (e.g. UUID) of the task.
  String taskId = '';

  A2ATaskPushNotificationConfig();

  factory A2ATaskPushNotificationConfig.fromJson(Map<String, dynamic> json) =>
      _$A2ATaskPushNotificationConfigFromJson(json);

  Map<String, dynamic> toJson() => _$A2ATaskPushNotificationConfigToJson(this);
}

/// A Structured value that holds the parameter values to be used during the invocation of
/// the method.
@JsonSerializable(explicitToJson: true)
class A2ATaskIdParams {
  /// Task id.
  String id = '';

  /// Metadata
  A2ASV? metadata;

  A2ATaskIdParams();

  factory A2ATaskIdParams.fromJson(Map<String, dynamic> json) =>
      _$A2ATaskIdParamsFromJson(json);

  Map<String, dynamic> toJson() => _$A2ATaskIdParamsToJson(this);
}

/// A Structured value that holds the parameter values to be used during the invocation of
/// the method.
@JsonSerializable(explicitToJson: true)
class A2ATaskQueryParams {
  /// Number of recent messages to be retrieved.
  int? historyLength;

  /// Task Id
  String id = '';

  /// Metadata
  A2ASV? metadata;

  A2ATaskQueryParams();

  factory A2ATaskQueryParams.fromJson(Map<String, dynamic> json) =>
      _$A2ATaskQueryParamsFromJson(json);

  Map<String, dynamic> toJson() => _$A2ATaskQueryParamsToJson(this);
}

/// A Structured value that holds the parameter values to be used during the invocation of
/// the method.
@JsonSerializable(explicitToJson: true)
class A2AMessageSendParams {
  A2AMessageSendConfiguration? configuration;
  A2AMessage message = A2AMessage();

  /// Extension metadata.
  A2ASV? metadata;

  A2AMessageSendParams();

  factory A2AMessageSendParams.fromJson(Map<String, dynamic> json) =>
      _$A2AMessageSendParamsFromJson(json);

  Map<String, dynamic> toJson() => _$A2AMessageSendParamsToJson(this);
}

/// Send message configuration.
@JsonSerializable(explicitToJson: true)
class A2AMessageSendConfiguration {
  /// Accepted output modalities by the client.
  List<String> acceptedOutputModes = [];

  /// If the server should treat the client as a blocking request.
  bool blocking = false;

  /// Number of recent messages to be retrieved.
  num? historyLength;

  A2APushNotificationConfig? pushNotificationConfig;

  A2AMessageSendConfiguration();

  factory A2AMessageSendConfiguration.fromJson(Map<String, dynamic> json) =>
      _$A2AMessageSendConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$A2AMessageSendConfigurationToJson(this);
}

/// Defines the configuration for setting up push notifications for task updates.
@JsonSerializable(explicitToJson: true)
class A2APushNotificationConfig {
  /// Optional authentication details for the agent to use when calling the notification URL.
  A2APushNotificationAuthenticationInfo? authentication;

  /// A unique identifier (e.g. UUID) for the push notification configuration, set by the client
  /// to support multiple notification callbacks.
  String? id;

  /// A unique token for this task or session to validate incoming push notifications.
  String? token;

  /// The callback URL where the agent should send push notifications.
  String url = '';

  A2APushNotificationConfig();

  factory A2APushNotificationConfig.fromJson(Map<String, dynamic> json) =>
      _$A2APushNotificationConfigFromJson(json);

  Map<String, dynamic> toJson() => _$A2APushNotificationConfigToJson(this);
}

/// Defines authentication details for a push notification endpoint.
@JsonSerializable(explicitToJson: true)
class A2APushNotificationAuthenticationInfo {
  /// Optional credentials required by the push notification endpoint.
  String? credentials;

  /// Supported authentication schemes - e.g. Basic, Bearer
  List<String> schemes = [];

  A2APushNotificationAuthenticationInfo();

  factory A2APushNotificationAuthenticationInfo.fromJson(
    Map<String, dynamic> json,
  ) => _$A2APushNotificationAuthenticationInfoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$A2APushNotificationAuthenticationInfoToJson(this);
}
