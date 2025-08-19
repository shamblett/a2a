/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

import 'package:colorize/colorize.dart';
import 'package:uuid/uuid.dart';

import 'package:a2a/a2a.dart';

/// A fully annotated example of how to construct an A2A Agent
/// using the Server SDK.
///
/// Status information is printed to the console, blue is for information,
/// yellow for an event that has occurred and red for failure

///
/// Step 1 - Define the Agent Card
///

final movieAgentCard = A2AAgentCard()
  ..name = 'Movie Agent'
  ..description =
      'An agent that can answer questions about movies and actors using TMDB.'
  // Adjust the base URL and port as needed.
  ..url = 'http://localhost:41241'
  ..agentProvider = (A2AAgentProvider()
    ..organization = 'A2A Agents'
    ..url = 'https://example.com/a2a-agents')
  ..version = '0.0.2'
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
      ..id = 'general_movie_chat'
      ..name = 'General Movie Chat'
      ..description =
          'Answer general questions or chat about movies, actors, directors.'
      ..tags = ['movies', 'actors', 'directors']
      ..examples = [
        'Tell me about the plot of Inception.',
        'Recommend a good sci-fi movie.',
        'Who directed The Matrix?',
        'What other movies has Scarlett Johansson been in?',
        'Find action movies starring Keanu Reeves',
        'Which came out first, Jurassic Park or Terminator 2?',
      ]
      ..inputModes = ['text/plain']
      ..outputModes = ['text/plain'],
  ])
  ..supportsAuthenticatedExtendedCard = false;

///
/// Step 2 - Define the Agent Executor
///

// 1. Define your agent's logic as an  A2AAgentExecutor
class MyAgentExecutor implements A2AAgentExecutor {
  final Set<String> _cancelledTasks = {};
  final _uuid = Uuid();

  @override
  Future<void> cancelTask(String taskId, A2AExecutionEventBus eventBus) async =>
      _cancelledTasks.add(taskId);
  // The execute loop is responsible for publishing the final state

  @override
  Future<void> execute(
    A2ARequestContext requestContext,
    A2AExecutionEventBus eventBus,
  ) async {
    final userMessage = requestContext.userMessage;
    final existingTask = requestContext.task;

    // Determine IDs for the task and context, from requestContext.
    final taskId = requestContext.taskId;
    final contextId = requestContext.contextId;

    print(
      '${Colorize('[MyAgentExecutor] Processing message ${userMessage.messageId} '
      'for task $taskId (context: $contextId)').blue()}',
    );

    // 1. Publish initial Task event if it's a new task
    if (existingTask == null) {
      final initialTask = A2ATask()
        ..id = taskId
        ..contextId = contextId
        ..status = (A2ATaskStatus()
          ..state = A2ATaskState.submitted
          ..timestamp = A2AUtilities.getCurrentTimestamp())
        ..history = [userMessage]
        ..metadata = userMessage.metadata
        ..artifacts = []; // // Initialize artifacts array
      eventBus.publish(initialTask);
    }

    // 2. Publish "working" status update
    final workingStatusUpdate = A2ATaskStatusUpdateEvent()
      ..taskId = taskId
      ..contextId = contextId
      ..status = (A2ATaskStatus()
        ..state = A2ATaskState.working
        ..message = (A2AMessage()
          ..role = 'agent'
          ..messageId = _uuid.v4()
          ..parts = [(A2ATextPart()..text = 'Generating code...')]
          ..taskId = taskId
          ..contextId = contextId)
        ..timestamp = A2AUtilities.getCurrentTimestamp())
      ..end = false;

    eventBus.publish(workingStatusUpdate);

    // Simulate work...
    await Future.delayed(Duration(seconds: 3));

    // Check for request cancellation
    if (_cancelledTasks.contains(taskId)) {
      print('${Colorize('Request cancelled for task: $taskId').yellow()}');
      final cancelledUpdate = A2ATaskStatusUpdateEvent()
        ..taskId = taskId
        ..contextId = contextId
        ..status = (A2ATaskStatus()
          ..state = A2ATaskState.canceled
          ..timestamp = A2AUtilities.getCurrentTimestamp())
        ..end = true;

      eventBus.publish(cancelledUpdate);
      eventBus.finished();
      return;
    }

    // 3. Publish artifact update
    final artifactUpdate = A2ATaskArtifactUpdateEvent()
      ..taskId = taskId
      ..contextId = contextId
      ..artifact = (A2AArtifact()
        ..artifactId = 'artifact-1'
        ..name = 'artifact-1'
        ..parts = [(A2ATextPart()..text = 'Task $taskId completed.')])
      ..append = false
      ..lastChunk = true;

    eventBus.publish(artifactUpdate);

    // 4. Publish final status update
    final finalUpdate = A2ATaskStatusUpdateEvent()
      ..taskId = taskId
      ..contextId = contextId
      ..status = (A2ATaskStatus()
        ..state = A2ATaskState.completed
        ..message = (A2AMessage()
          ..role = 'agent'
          ..messageId = _uuid.v4()
          ..taskId = taskId
          ..contextId = contextId)
        ..timestamp = A2AUtilities.getCurrentTimestamp())
      ..end = true;

    eventBus.publish(finalUpdate);
    eventBus.finished();
  }
}

///
/// Step 3 - Start the server
///

void main() {
  // Initialise the required server components for the express application
  final taskStore = A2AInMemoryTaskStore();
  final agentExecutor = MyAgentExecutor();
  final eventBusManager = A2ADefaultExecutionEventBusManager();
  final requestHandler = A2ADefaultRequestHandler(
    movieAgentCard,
    taskStore,
    agentExecutor,
    eventBusManager,
  );
  final transportHandler = A2AJsonRpcTransportHandler(requestHandler);

  // Initialise the express app
  final appBuilder = A2AExpressApp(requestHandler, transportHandler);
  final expressApp = appBuilder.setupRoutes(Darto(), '');

  // Start listening
  const port = 41242;
  expressApp.listen(port, () {
    print(
      '${Colorize('[MyAgent] Server using new framework started on http://localhost:$port').blue()}',
    );
    print(
      '${Colorize('MyAgent] Agent Card: http://localhost:$port}/.well-known/agent-card.json').blue()}',
    );
    print('${Colorize('[MyAgent] Press Ctrl+C to stop the server').blue()}');
  });
}
