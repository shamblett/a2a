/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_server.dart';

abstract interface class A2ARequestHandler {
  Future<A2AAgentCard> get agentCard;

  Future<A2AAgentCard> get authenticatedExtendedAgentCard;

  Future<A2ATaskOrMessage> sendMessage(A2AMessageSendParams params);

  Stream<A2AResult> sendMessageStream(A2AMessageSendParams params);

  Future<A2ATask> getTask(A2ATaskQueryParams params);

  Future<A2ATask> cancelTask(A2ATaskIdParams params);

  Future<A2APushNotificationConfig>? setTaskPushNotificationConfig(
    A2ATaskPushNotificationConfig params,
  );

  Future<A2APushNotificationConfig>? getTaskPushNotificationConfig(
    A2ATaskIdParams params,
  );

  Future<List<A2APushNotificationConfig>>? listTaskPushNotificationConfigs(
    A2AListTaskPushNotificationConfigParams params,
  );

  Future<void> deleteTaskPushNotificationConfig(
    A2ADeleteTaskPushNotificationConfigParams params,
  );

  /// Does not return A2AMessage
  Stream<A2AResult> resubscribe(A2ATaskIdParams params);
}
