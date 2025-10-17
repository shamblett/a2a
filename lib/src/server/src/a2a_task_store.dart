/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../a2a_server.dart';

/// Simplified interface for task storage providers.
/// Stores and retrieves the task.
abstract interface class A2ATaskStore {
  /// Saves a task.
  /// Overwrites existing data if the task ID exists.
  /// @param data the task.
  /// @returns A Future resolving when the save operation is complete.
  Future<void> save(A2ATask data);

  /// Loads a task by task ID.
  /// @param taskId The ID of the task to load.
  /// @returns A Future resolving to the Task, or null if not found.
  Future<A2ATask?> load(String taskId);
}

///  In memory task store
class A2AInMemoryTaskStore implements A2ATaskStore {
  final Map<String, A2ATask> _store = {};

  /// Count of tasks
  int get count => _store.length;

  @override
  Future<void> save(A2ATask task) async {
    final clone = task.clone();
    _store[task.id] = clone;
  }

  @override
  Future<A2ATask?> load(String taskId) {
    // Return copies to prevent external mutation
    A2ATask? task;
    final completer = Completer<A2ATask?>();
    if (_store.containsKey(taskId)) {
      task = _store[taskId];
    }
    completer.complete(task);
    return completer.future;
  }
}
