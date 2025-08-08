/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../a2a_server.dart';

class A2AResultManager {
  final A2ATaskStore _taskStore;

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
      _currentTask?.history ??= [];
      if (_latestUserMessage != null) {
        if (_currentTask?.history?.contains(_latestUserMessage) == false) {
          _currentTask?.history?.add(_latestUserMessage!);
        }
      }

      await _saveCurrentTask();
    } else if (event is A2ATaskStatusUpdateEvent) {
      if (_currentTask != null && _currentTask?.id == event.taskId) {
        _currentTask ??= A2ATask();
        _currentTask?.status = event.status;
        if (event.status?.message != null) {
          if (_currentTask?.history?.contains(event.status?.message) == false) {
            _currentTask?.history?.add(event.status!.message!);
          }
        }
        await _saveCurrentTask();
      } else if (_currentTask == null) {
        // Potentially an update for a task we haven't seen the 'task' event for yet,
        // or we are rehydrating. Attempt to load.
        final loaded = await _taskStore.load(event.taskId);
        if (loaded != null) {
          _currentTask = loaded;
          _currentTask ??= A2ATask();
          _currentTask?.status = event.status;
          if (_currentTask?.history?.contains(event.status?.message) == false) {
            _currentTask?.history?.add(event.status!.message!);
          }
          await _saveCurrentTask();
        } else {
          print(
            'A2AResultManager :: Received status update for unknown task ${event.taskId}',
          );
        }
      }
    } else if (event is A2ATaskArtifactUpdateEvent) {
      if (_currentTask?.id == event.taskId) {
        _currentTask?.artifacts ??= [];
        final eventArtifact = event.artifact ?? A2AArtifact();
        final index = _currentTask?.artifacts?.indexOf(eventArtifact);
        if (index != -1) {
          if (event.append == true) {
            // Basic append logic, assuming parts are compatible
            // More sophisticated merging might be needed for specific part types
            final existingArtifact = _currentTask?.artifacts![index!];

          } else {
            _currentTask?.artifacts?[index!] = eventArtifact;
          }
        } else {
          _currentTask?.artifacts?.add(eventArtifact);
        }
      }
    }
  }

  Future<void> _saveCurrentTask() async {
    if (_currentTask != null) {
      await _taskStore.save(_currentTask!);
    }
  }
}
