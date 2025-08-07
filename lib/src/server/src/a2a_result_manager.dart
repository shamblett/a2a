/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../a2a_server.dart';

class A2AResultManager {
  A2ATaskStore _taskStore;

  A2ATask? _currentTask;

  // To add to history if a new task is created
  A2AMessage? _latestUserMessage;

  // Stores the message if it's the final result
  A2AMessage? _finalMessageResult;

  set context(A2AMessage latestUserMessage) =>
      _latestUserMessage = latestUserMessage;

  A2AResultManager(this._taskStore);

  /// Processes an agent execution event and updates the task store.
  /// @param event The agent execution event.
  Future<void> processEvent(A2AAgentExecutionEvent event) async {
    // If a message is received, it's usually the final result,
    // but we continue processing to ensure task state (if any) is also saved.
    // The ExecutionEventQueue will stop after a message event.
    if (event is A2AMessage) {
      _finalMessageResult = event;
    } else if (event is A2ATask) {
      // Make a copy
      _currentTask = event.clone();

      // Ensure the latest user message is in history if not already present
      if (_latestUserMessage != null) {
        if (_currentTask?.history?.contains(_latestUserMessage) == false) {
          _currentTask?.history?.add(_latestUserMessage!);
        }
      }

      await _saveCurrentTask();
    } else if (event is A2ATaskStatusUpdateEvent) {
    } else if (event is A2ATaskArtifactUpdateEvent) {}
  }

  Future<void> _saveCurrentTask() async {
    if (_currentTask != null) {
      await _taskStore.save(_currentTask!);
    }
  }
}
