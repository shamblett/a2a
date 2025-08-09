/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_server.dart';

abstract interface class A2AExecutionEventBus {
  static const a2aEBFinished = 'finished';
  static const a2aEBEvent = 'event';

  void publish(A2AAgentExecutionEvent event);

  EventListener<T> on<T>(String? type, EventCallback<T> callback);

  bool off<T>({String? type, EventCallback<T>? callback});

  Future<T> once<T>(String? type, [EventCallback<T>? callback]);

  bool removeEventListener<T>(EventListener<T> listener);

  void removeAllListeners(String type);

  void finished();
}

class A2ADefaultExecutionEventBus extends EventEmitter
    implements A2AExecutionEventBus {
  @override
  void publish(A2AAgentExecutionEvent event) =>
      emit(A2AExecutionEventBus.a2aEBEvent, event);

  @override
  void finished() => emit(A2AExecutionEventBus.a2aEBFinished);

  @override
  void removeAllListeners(String type) {
    for (final listener in listeners) {
      if (listener.type == type) {
        removeEventListener(listener);
      }
    }
  }
}
