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
