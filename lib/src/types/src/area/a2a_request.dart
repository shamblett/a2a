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

final class SendStreamingMessageRequest extends A2ARequest {}

final class GetTaskRequest extends A2ARequest {}

final class CancelTaskRequest extends A2ARequest {}

final class SetTaskPushNotificationConfigRequest extends A2ARequest {}

final class GetTaskPushNotificationConfigRequest extends A2ARequest {}

final class TaskResubscriptionRequest extends A2ARequest {}

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
