/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

import 'package:colorize/colorize.dart';
import 'package:uuid/uuid.dart';
import 'package:dartantic_ai/dartantic_ai.dart';
import 'package:a2a/a2a.dart';

/// A fully annotated example of how to construct an A2A Agent
/// using the Server SDK.
///
/// This is a runnable example of an A2A Agent -
///
/// dart examples/a2a_server_agent_ollama.dart
///
/// Starts the agent server on http://localhost:41242
///
/// You can then use the client API or the a2a_cli_client to
/// interact with the agent.
///
/// Ensure you have a local ollama installation service running on its usual port
/// that supports the gemma3 and gemma3:270m models.
///
/// Status information is printed to the console, blue is for information,
/// yellow for an event that has occurred and red for failure. If you enable
/// server debug this output will be in green.

///
/// Step 1 - Define the Agent Card
///

final movieAgentCard = A2AAgentCard()
  ..name = 'LLM Comparison Agent'
  ..description =
      'An agent that sends a prompt to two LLM\'s, gemma3 and gemma3:270m models '
      'allowing the response from each model to be compared.'
  // Adjust the base URL and port as needed.
  ..url = 'http://localhost:41242/'
  ..agentProvider = (A2AAgentProvider()
    ..organization = 'Darticulate A2A Agents'
    ..url = 'https://example.com/a2a-agents')
  ..version = '1.0.0'
  ..capabilities =
      (A2AAgentCapabilities()
        ..streaming =
            true // Supports streaming
        ..pushNotifications =
            false //  Assuming not implemented for this agent yet
        ..stateTransitionHistory = true) // Agent uses history
  ..securitySchemes =
      null // Or define actual security schemes if any
  ..security = null
  ..defaultInputModes = ['text/plain']
  ..defaultOutputModes = ['text/plain']
  ..skills = ([
    A2AAgentSkill()
      ..id = 'llm_comparison'
      ..name = 'LLM Comparison'
      ..description = 'Compare the responses of two LLM\'s for the same prompt.'
      ..tags = ['LLM', 'gemma']
      ..examples = ['What is Paris famous for?']
      ..inputModes = ['text/plain']
      ..outputModes = ['text/plain'],
  ])
  ..supportsAuthenticatedExtendedCard = false;

///
/// Step 2 - Define the Agent Executor
///

// 1. Define your agent's logic as an  A2AAgentExecutor
class LLMComparisonExecutor implements A2AAgentExecutor {
  final _uuid = Uuid();

  /// Executor construction helper.
  /// Late is OK here, a task cannot be cancelled until it has been created,
  /// which is done in the execute method.
  late A2AExecutorConstructor ec;

  @override
  Future<void> cancelTask(String taskId, A2AExecutionEventBus eventBus) async =>
      ec.cancelTask = taskId;
  // The execute loop is responsible for publishing the final state

  @override
  Future<void> execute(
    A2ARequestContext requestContext,
    A2AExecutionEventBus eventBus,
  ) async {
    /// Create the executor construction helper
    ec = A2AExecutorConstructor(requestContext, eventBus);

    print(
      '${Colorize('[LLMComparisonExecutor] Processing message ${ec.userMessage.messageId} '
      'for task ${ec.taskId} (context: ${ec.contextId})').blue()}',
    );

    // 1. Publish initial Task event if it's a new task
    if (ec.existingTask == null) {
      ec.publishInitialTaskUpdate();
    }

    // 2. Publish "working" status update
    final textPart = ec.createTextPart('Querying the LLM\'s');
    ec.publishWorkingTaskUpdate(part: [textPart]);

    await ec.delay(2000);
    // TODo query the LLM's here

    // Check for request cancellation
    if (ec.isTaskCancelled) {
      print('${Colorize('Request cancelled for task: ${ec.taskId}').yellow()}');
      ec.publishCancelTaskUpdate();
      return;
    }

    // 3. Publish artifact update
    final artifactUpdate = A2ATaskArtifactUpdateEvent()
      ..taskId = ec.taskId
      ..contextId = ec.contextId
      ..artifact = (A2AArtifact()
        ..artifactId = 'artifact-1'
        ..name = 'artifact-1'
        ..parts = [
          (A2ATextPart()
            ..text = 'Artifact update from the LLM Comparison Agent'),
        ])
      ..append = false
      ..lastChunk = true;

    eventBus.publish(artifactUpdate);

    // 4. Publish final status update
    final finalUpdate = A2ATaskStatusUpdateEvent()
      ..taskId = ec.taskId
      ..contextId = ec.contextId
      ..status = (A2ATaskStatus()
        ..state = A2ATaskState.completed
        ..message = (A2AMessage()
          ..role = 'agent'
          ..messageId = _uuid.v4()
          ..taskId = ec.taskId
          ..contextId = ec.contextId)
        ..timestamp = A2AUtilities.getCurrentTimestamp())
      ..end = true;

    eventBus.publish(finalUpdate);
  }
}

///
/// Step 3 - Start the server
///

/// Define a middleware function to log incoming requests
final mwLogging = ((Request req, Response res, NextFunction next) {
  print(
    '${Colorize('📝 Request: ${req.method} ${req.uri} from ${req.hostname}').blue()}',
  );
  next();
});

void main() {
  /// Initialise the required server components for the express application
  final taskStore = A2AInMemoryTaskStore();
  final agentExecutor = LLMComparisonExecutor();
  final eventBusManager = A2ADefaultExecutionEventBusManager();
  final requestHandler = A2ADefaultRequestHandler(
    movieAgentCard,
    taskStore,
    agentExecutor,
    eventBusManager,
    null,
  );
  final transportHandler = A2AJsonRpcTransportHandler(requestHandler);

  /// Initialise the Darto application with the middleware logger.
  /// You can add as many middleware functions as you wish, each
  /// chained to the next.
  final appBuilder = A2AExpressApp(requestHandler, transportHandler);
  final expressApp = appBuilder.setupRoutes(
    Darto(),
    '',
    middlewares: [mwLogging],
  );

  // Turn on debug if needed
  // A2AServerDebug.on();

  // Start listening
  const port = 41242;
  expressApp.listen(port, () {
    print(
      '${Colorize('[MyAgent] Server using new framework started on http://localhost:$port').blue()}',
    );
    print(
      '${Colorize('[MyAgent] Agent Card: http://localhost:$port}/.well-known/agent-card.json').blue()}',
    );
    print('${Colorize('[MyAgent] Press Ctrl+C to stop the server').blue()}');
    print('');
  });
}
