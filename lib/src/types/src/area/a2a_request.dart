/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// A2A supported request types
sealed class A2ARequest {}

final class A2ASendMessageRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  final method = 'message/send';
}

/// JSON-RPC request model for the 'message/stream' method.
final class A2ASendStreamingMessageRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  final method = 'message/stream';
  A2AMessageSendParams? params;
}

/// JSON-RPC request model for the 'tasks/get' method.
final class A2AGetTaskRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  final method = 'tasks/get';
  A2ATaskQueryParams? params;
}

/// JSON-RPC request model for the 'tasks/cancel' method.
final class A2ACancelTaskRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  String method = 'tasks/cancel';
  A2ATaskIdParams? params;
}

/// JSON-RPC request model for the 'tasks/pushNotificationConfig/set' method.
final class A2ASetTaskPushNotificationConfigRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  String method = 'tasks/pushNotificationConfig/set';
  A2ATaskPushNotificationConfig? params;
}

/// JSON-RPC request model for the 'tasks/pushNotificationConfig/get' method.
final class A2AGetTaskPushNotificationConfigRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  String method = 'tasks/pushNotificationConfig/get';
  A2ATaskIdParams? params;
}

/// JSON-RPC request model for the 'tasks/resubscribe' method.
final class A2ATaskResubscriptionRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  String method = 'tasks/resubscribe';
  A2ATaskIdParams? params;
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

/// A Structured value that holds the parameter values to be used during the invocation of
/// the method.
class A2ATaskPushNotificationConfig {
  A2ATaskPushNotificationConfig1? pushNotificationConfig;

  /// Task Id
  String id = '';
}

/// A Structured value that holds the parameter values to be used during the invocation of
/// the method.
class A2ATaskIdParams {
  /// Task id.
  String id = '';

  /// Metadata
  A2ASV? metadata;
}

/// A Structured value that holds the parameter values to be used during the invocation of
/// the method.
class A2ATaskQueryParams {
  /// Number of recent messages to be retrieved.
  int? historyLength;

  /// Task Id
  String id = '';

  /// Metadata
  A2ASV? metadata;
}

/// A Structured value that holds the parameter values to be used during the invocation of
/// the method.
class A2AMessageSendParams {
  A2AMessageSendConfiguration? configuration;
  A2AMessage message = A2AMessage();

  /// Extension metadata.
  A2ASV? metadata;
}

/// Send message configuration.
class A2AMessageSendConfiguration {
  /// Accepted output modalities by the client.
  List<String> acceptedOutputModes = [];

  /// If the server should treat the client as a blocking request.
  bool blocking = false;

  /// Number of recent messages to be retrieved.
  num? historyLength;

  A2APushNotificationConfig? pushNotificationConfig;
}

/// Where the server should send notifications when disconnected.
class A2APushNotificationConfig {
  A2APushNotificationAuthenticationInfo? authentication;

  /// Push Notification ID - created by server to support multiple callbacks
  String? id;

  /// Token unique to this task/session.
  String? token;

  /// URL for sending the push notifications.
  String url = '';
}

/// Defines authentication details for push notifications.
@JsonSerializable(explicitToJson: true)
class A2APushNotificationAuthenticationInfo {
  /// Optional credentials
  String? credentials;

  /// Supported authentication schemes - e.g. Basic, Bearer
  List<String> schemes = [];

  A2APushNotificationAuthenticationInfo();

  factory A2APushNotificationAuthenticationInfo.fromJson(Map<String, dynamic> json) =>
      _$A2APushNotificationAuthenticationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$A2APushNotificationAuthenticationInfoToJson(this);
}

