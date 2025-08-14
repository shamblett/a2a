/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_server.dart';

abstract interface class A2AAgentExecutor {
  /// Executes the agent logic based on the request context and publishes events.
  /// @param requestContext The context of the current request.
  /// @param eventBus The bus to publish execution events to
  Future<void> execute(
    A2ARequestContext requestContext,
    A2AExecutionEventBus eventBus,
  );

  /// Method to explicitly cancel a running task.
  /// The implementation should handle the logic of stopping the execution
  /// and publishing the final 'canceled' status event on the provided event bus.
  /// @param taskId The ID of the task to cancel.
  /// @param eventBus The event bus associated with the task's execution.
  Future<void> cancelTask(String taskId, A2AExecutionEventBus eventBus);
}
