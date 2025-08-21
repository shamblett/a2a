/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_server.dart';

/// An async queue that subscribes to an ExecutionEventBus for events
/// and provides an async generator to consume them.
class A2AExecutionEventQueue {
  final A2AExecutionEventBus _eventBus;

  final Queue<A2AAgentExecutionEvent> _eventQueue = Queue();

  bool _stopped = false;

  int get count => _eventQueue.length;

  A2AExecutionEventQueue(A2AExecutionEventBus eventBus) : _eventBus = eventBus {
    _eventBus.on(A2AExecutionEventBus.a2aEBEvent, _handleEvent);
    _eventBus.on(A2AExecutionEventBus.a2aEBFinished, _handleFinished);
  }

  /// Provides an async generator that yields events from the event bus.
  /// Stops when a Message event is received or a TaskStatusUpdateEvent with final=true is received.
  Stream<A2AAgentExecutionEvent> events() async* {
    while (!_stopped && count > 0) {
      final event = _eventQueue.removeFirst();
      if (event is A2AMessage) {
        _stopped = true;
      }
      if (event is A2ATaskStatusUpdateEvent) {
        if (event.end != null) {
          if (event.end == true) {
            _stopped = true;
          }
        }
      }
      yield event;
    }
  }

  /// Stops the event queue from processing further events.
  void stop() {
    _stopped = true;
    _eventBus.off(
      type: A2AExecutionEventBus.a2aEBEvent,
      callback: _handleEvent,
    );
    _eventBus.off(
      type: A2AExecutionEventBus.a2aEBFinished,
      callback: _handleFinished,
    );
  }

  void _handleEvent(A2AAgentExecutionEvent event) {
    if (_stopped) {
      return;
    }
    _eventQueue.addLast(event);
  }

  void _handleFinished(_) => _stopped = true;
}
