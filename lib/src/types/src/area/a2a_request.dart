/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// A2A supported request types
base class A2ARequest {}

final class SendMessageRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  Id? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  final method = 'message/send';
}

/// JSON-RPC request model for the 'message/stream' method.
final class SendStreamingMessageRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  Id? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  final method = 'message/stream';
  MessageSendParams? params;
}

/// JSON-RPC request model for the 'tasks/get' method.
final class GetTaskRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  Id? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  final method = 'tasks/get';
  TaskQueryParams? params;
}

/// JSON-RPC request model for the 'tasks/cancel' method.
final class CancelTaskRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  Id? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  String method = 'tasks/cancel';
  TaskIdParams? params;
}

/// JSON-RPC request model for the 'tasks/pushNotificationConfig/set' method.
final class SetTaskPushNotificationConfigRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  Id? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  String method = 'tasks/pushNotificationConfig/set';
  TaskPushNotificationConfig? params;
}

/// JSON-RPC request model for the 'tasks/pushNotificationConfig/get' method.
final class GetTaskPushNotificationConfigRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  Id? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  String method = 'tasks/pushNotificationConfig/get';
  TaskIdParams? params;
}

/// JSON-RPC request model for the 'tasks/resubscribe' method.
final class TaskResubscriptionRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  Id? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  String method = 'tasks/resubscribe';
  TaskIdParams? params;
}

class TaskPushNotificationConfig1 {
  PushNotificationAuthenticationInfo? authentication;

  /// Push Notification ID - created by server to support multiple callbacks
  String id = '';

  /// Token unique to this task/session.
  String? token;

  /// URL for sending the push notifications.
  String url = '';
}

class TaskPushNotificationConfig {
  TaskPushNotificationConfig1? pushNotificationConfig;

  /// Task Id
  String id = '';
}

class TaskIdParams {
  /// Task id.
  String id = '';

  /// Metadata
  SV? metadata;
}

class TaskQueryParams {
  /// Number of recent messages to be retrieved.
  int? historyLength;

  /// Task Id
  String id = '';

  /// Metadata
  SV? metadata;
}

class MessageSendParams {
  MessageSendConfiguration? configuration;
  Message message = Message();

  /// Extension metadata.
  SV? metadata;
}

class MessageSendConfiguration {
  /// Accepted output modalities by the client.
  List<String> acceptedOutputModes = [];

  /// If the server should treat the client as a blocking request.
  bool blocking = false;

  /// Number of recent messages to be retrieved.
  num? historyLength;

  PushNotificationConfig? pushNotificationConfig;
}

class PushNotificationConfig {
  PushNotificationAuthenticationInfo? authentication;

  /// Push Notification ID - created by server to support multiple callbacks
  String? id;

  /// Token unique to this task/session.
  String? token;

  /// URL for sending the push notifications.
  String url = '';
}

class PushNotificationAuthenticationInfo {
  /// Optional credentials
  String? credentials;

  /// Supported authentication schemes - e.g. Basic, Bearer
  List<String> schemes = [];
}
