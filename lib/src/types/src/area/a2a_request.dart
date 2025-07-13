/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// A2A supported request types
base class A2ARequest {}

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
  TaskIdParams? params;
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
  TaskIdParams? params;
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
  TaskIdParams? params;
}

class A2ATaskPushNotificationConfig1 {
  A2APushNotificationAuthenticationInfo? authentication;

  /// Push Notification ID - created by server to support multiple callbacks
  String id = '';

  /// Token unique to this task/session.
  String? token;

  /// URL for sending the push notifications.
  String url = '';
}

class A2ATaskPushNotificationConfig {
  A2ATaskPushNotificationConfig1? pushNotificationConfig;

  /// Task Id
  String id = '';
}

class TaskIdParams {
  /// Task id.
  String id = '';

  /// Metadata
  A2ASV? metadata;
}

class A2ATaskQueryParams {
  /// Number of recent messages to be retrieved.
  int? historyLength;

  /// Task Id
  String id = '';

  /// Metadata
  A2ASV? metadata;
}

class A2AMessageSendParams {
  A2AMessageSendConfiguration? configuration;
  A2AMessage message = A2AMessage();

  /// Extension metadata.
  A2ASV? metadata;
}

class A2AMessageSendConfiguration {
  /// Accepted output modalities by the client.
  List<String> acceptedOutputModes = [];

  /// If the server should treat the client as a blocking request.
  bool blocking = false;

  /// Number of recent messages to be retrieved.
  num? historyLength;

  A2APushNotificationConfig? pushNotificationConfig;
}

class A2APushNotificationConfig {
  A2APushNotificationAuthenticationInfo? authentication;

  /// Push Notification ID - created by server to support multiple callbacks
  String? id;

  /// Token unique to this task/session.
  String? token;

  /// URL for sending the push notifications.
  String url = '';
}

class A2APushNotificationAuthenticationInfo {
  /// Optional credentials
  String? credentials;

  /// Supported authentication schemes - e.g. Basic, Bearer
  List<String> schemes = [];
}
