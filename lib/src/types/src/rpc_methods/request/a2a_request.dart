/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../../a2a_types.dart';

/// A2A supported request types
class A2ARequest {
  static const messageSend = 'message/send';
  static const messageStream = 'message/stream';
  static const tasksGet = 'tasks/get';
  // Defined in the protocol specification only for gRPC and REST
  // so not implemented here with the only supported transport being JSON-RPC
  static const tasksList = 'tasks/list';
  static const tasksCancel = 'tasks/cancel';
  static const tasksPncSet = 'tasks/pushNotificationConfig/set';
  static const tasksPncGet = 'tasks/pushNotificationConfig/get';
  static const tasksPncList = 'tasks/pushNotificationConfig/list';
  static const tasksPncDelete = 'tasks/pushNotificationConfig/delete';
  static const tasksResubscribe = 'tasks/resubscribe';
  // TODO
  static const getAuthenticatedAgentCard = 'agent/getAuthenticatedExtendedCard';

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
  String method = A2ARequest.tasksResubscribe;

  A2ATaskIdParams? params;

  A2ATaskResubscriptionRequest();

  factory A2ATaskResubscriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$A2ATaskResubscriptionRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2ATaskResubscriptionRequestToJson(this);
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
