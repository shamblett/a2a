/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_server.dart';

abstract interface class A2ARequestHandler {
  Future<A2AAgentCard> get agentCard;

  Future<A2ATaskOrMessage> sendMessage(A2AMessageSendParams params);

  Stream<A2AResult> sendMessageStream(A2AMessageSendParams params);

  Future<A2ATask> getTask(A2ATaskQueryParams);

  Future<A2ATask> cancelTask(A2ATaskQueryParams);

  Future<A2ATaskPushNotificationConfig>? setTaskPushNotificationConfig (A2ATaskPushNotificationConfig);

  Future<A2ATaskPushNotificationConfig>? getTaskPushNotificationConfig (A2ATaskIdParams);

  /// Does not return A2AMessage
  Stream<A2AResult> resubscribe(A2ATaskIdParams);
}

