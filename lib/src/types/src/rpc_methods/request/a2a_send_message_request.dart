/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 30/06/2026
* Copyright :  S.Hamblett
*/

part of '../../../a2a_types.dart';

/// JSON-RPC request model for the 'message/send' method.
@JsonSerializable(explicitToJson: true)
final class A2ASendMessageRequest extends A2ARequest {
  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  @JsonKey(includeToJson: true, includeFromJson: false)
  String jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  @JsonKey(includeToJson: true, includeFromJson: false)
  String method = A2ARequest.messageSend;

  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  A2AMessageSendParams? params;

  A2ASendMessageRequest();

  factory A2ASendMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$A2ASendMessageRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2ASendMessageRequestToJson(this);
}

/// Defines the parameters for a request to send a message to an agent. This can be used
/// to create a new task, continue an existing one, or restart a task.
@JsonSerializable(explicitToJson: true)
class A2AMessageSendParams {
  /// The message object being sent to the agent.
  A2AMessage message = A2AMessage();

  /// Optional configuration for the send request
  A2AMessageSendConfiguration? configuration;

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

  /// The number of most recent messages from the task's history to retrieve in the response.
  num? historyLength;

  /// Configuration for the agent to send push notifications for updates after the initial response.
  A2APushNotificationConfig? pushNotificationConfig;

  /// If true, the client will wait for the task to complete.
  /// The server may reject this if the task is long-running.
  bool? blocking;

  A2AMessageSendConfiguration();

  factory A2AMessageSendConfiguration.fromJson(Map<String, dynamic> json) =>
      _$A2AMessageSendConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$A2AMessageSendConfigurationToJson(this);
}
