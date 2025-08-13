/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_server.dart';

const terminalStates = [
  A2ATaskState.completed,
  A2ATaskState.failed,
  A2ATaskState.canceled,
  A2ATaskState.rejected,
];

class A2ADefaultRequestHandler implements A2ARequestHandler {
  final A2AAgentCard _agentCard;

  final A2ATaskStore _taskStore;

  final A2AAgentExecutor _agentExecutor;

  final A2AExecutionEventBusManager _eventBusManager;

  // Store for push notification configurations (could be part of TaskStore or separate)
  final Map<String, A2APushNotificationConfig> _pushNotificationConfigs = {};

  @override
  Future<A2AAgentCard> get agentCard async => _agentCard;

  A2ADefaultRequestHandler(
    this._agentCard,
    this._taskStore,
    this._agentExecutor,
    this._eventBusManager,
  );
}
