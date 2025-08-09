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

  /// Creates or retrieves an existing ExecutionEventBus based on the taskId.
  /// @param taskId The ID of the task.
  /// @returns An instance of IExecutionEventBus.
  A2AExecutionEventBus createOrGetByTaskId(String taskId) {
    if (_taskIdToBus.keys.contains(taskId)) {
      _taskIdToBus[taskId] = A2ADefaultExecutionEventBus();
    }
    return _taskIdToBus[taskId]!;
  }

  /// Retrieves an existing ExecutionEventBus based on the taskId.
  /// @param taskId The ID of the task.
  /// @returns An instance of IExecutionEventBus or undefined if not found.
  A2AExecutionEventBus? getByTaskId(String taskId) => return _taskIdToBus[taskId];

  }
}
