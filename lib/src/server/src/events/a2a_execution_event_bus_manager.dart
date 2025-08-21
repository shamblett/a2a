/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_server.dart';

abstract interface class A2AExecutionEventBusManager {
  A2AExecutionEventBus? getByTaskId(String taskId);

  A2AExecutionEventBus? createOrGetByTaskId(String taskId);

  void cleanupByTaskId(String taskId);
}

class A2ADefaultExecutionEventBusManager
    implements A2AExecutionEventBusManager {
  final Map<String, A2AExecutionEventBus> _taskIdToBus = {};

  /// Creates or retrieves an existing [A2AExecutionEventBus] based on the taskId.
  /// @param taskId The ID of the task.
  /// @returns An instance of [A2AExecutionEventBus].
  @override
  A2AExecutionEventBus createOrGetByTaskId(String taskId) {
    if (!_taskIdToBus.keys.contains(taskId)) {
      _taskIdToBus[taskId] = A2ADefaultExecutionEventBus();
    }
    return _taskIdToBus[taskId]!;
  }

  /// Retrieves an existing [A2AExecutionEventBus] based on the taskId.
  /// @param taskId The ID of the task.
  /// @returns An instance of [A2AExecutionEventBus] or undefined if not found.
  @override
  A2AExecutionEventBus? getByTaskId(String taskId) => _taskIdToBus[taskId];

  /// Removes the event bus for a given taskId.
  /// This should be called when an execution flow is complete to free resources.
  /// @param taskId The ID of the task.
  @override
  void cleanupByTaskId(String taskId) {
    final bus = _taskIdToBus[taskId];
    if (bus != null) {
      bus.removeAllListeners(taskId);
    }
    _taskIdToBus.remove(taskId);
  }
}
