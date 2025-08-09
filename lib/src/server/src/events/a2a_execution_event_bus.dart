/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_server.dart';

abstract interface class A2AExecutionEventBus {
  void publish(A2AAgentExecutionEvent event);

  void finished();
}

class A2ADefaultExecutionEventBus extends EventEmitter
    implements A2AExecutionEventBus {
  @override
  void publish(A2AAgentExecutionEvent event) => emit('event', event);

  @override
  void finished() => emit('finished');
}
