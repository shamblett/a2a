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
  static const tasksPncList = 'tasks/pushNotificationConfig/list';
  static const tasksPncDelete = 'tasks/pushNotificationConfig/delete';
  static const tasksResubscribe = 'tasks/resubscribe';

  /// Set if a valid request cannot be formed by [fromJson].
  @JsonKey(includeFromJson: false)
  bool unknownRequest = false;

  factory A2ARequest.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('method')) {
      print('${Colorize('Error: JSON has no "method" key.').red()}');
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
        case tasksPncList:
          return A2AListTaskPushNotificationConfigRequest.fromJson(json);
        case tasksPncDelete:
          return A2ADeleteTaskPushNotificationConfigRequest.fromJson(json);
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
  String method = A2ARequest.messageSend;

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
  String method = A2ARequest.messageStream;

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
  String method = A2ARequest.tasksGet;

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
  String method = A2ARequest.tasksCancel;

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
  String method = A2ARequest.tasksPncSet;

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
  /// The unique identifier (e.g. UUID) of the task.
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

/// Defines the parameters for a request to send a message to an agent. This can be used
/// to create a new task, continue an existing one, or restart a task.
@JsonSerializable(explicitToJson: true)
class A2AMessageSendParams {
  /// Optional configuration for the send request
  A2AMessageSendConfiguration? configuration;

  /// The message object being sent to the agent.
  A2AMessage message = A2AMessage();

  /// Optional metadata for extensions.
  A2ASV? metadata;

  /// A list of extensions the client intends to activate.
  /// These are sent in the X-A2A-Extensions HTTP header and not in the
  /// message body, hence they are not part of the JSON serialization.
  @JsonKey(includeToJson: false, includeFromJson: false)
  List<String> extensions = [];

  A2AMessageSendParams();

  factory A2AMessageSendParams.fromJson(Map<String, dynamic> json) =>
      _$A2AMessageSendParamsFromJson(json);

  Map<String, dynamic> toJson() => _$A2AMessageSendParamsToJson(this);
}

/// Defines configuration options for a `message/send` or `message/stream` request.
@JsonSerializable(explicitToJson: true)
class A2AMessageSendConfiguration {
  /// A list of output MIME types the client is prepared to accept in the response.
  List<String> acceptedOutputModes = [];

  /// If true, the client will wait for the task to complete. The server may reject this if the task is long-running.
  bool? blocking;

  /// The number of most recent messages from the task's history to retrieve in the response.
  num? historyLength;

  /// Configuration for the agent to send push notifications for updates after the initial response.
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
