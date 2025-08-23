/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

import 'package:colorize/colorize.dart';
import 'package:uuid/uuid.dart';

import 'package:a2a/a2a.dart';

/// An implementation of the A2A helloworld sample agent
/// originally implemented in Python, see [here](https://github.com/a2aproject/a2a-samples/tree/main/samples/python/agents/helloworld)
///
/// This is a runnable example of an A2A Agent -
///
/// dart examples/a2a_server_agent_helloworld.dart
///
/// Starts the agent server on http://localhost:41242
///
/// You can then use the client API or the a2a_cli_client to
/// interact with the agent.
///
/// Status information is printed to the console, blue is for information,
/// yellow for an event that has occurred and red for failure
///
/// Note that unlike the Python example this example does not support
/// Authenticated Extended Card.
///

///
/// Step 1 - Define the Agent Card
///

final helloworldAgentCard = A2AAgentCard()
  ..name = 'Hello World Agent'
  ..description = 'Just a hello world agent'
  // Adjust the base URL and port as needed.
  ..url = 'http://localhost:9999/'
  ..version = '1.0.0'
  ..capabilities =
      (A2AAgentCapabilities()..streaming = true) // Supports streaming)
  ..securitySchemes =
      null // Or define actual security schemes if any
  ..security = null
  ..defaultInputModes = ['text']
  ..defaultOutputModes = ['text']
  ..skills = ([
    A2AAgentSkill()
      ..id = 'hello_world'
      ..name = 'Returns hello world'
      ..description = 'just returns hello world'
      ..tags = ['hello world']
      ..examples = ['hi', 'hello world']
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

    // 2. Publish a message update
    // No need for artifact or task update generation.
    // A generated message will terminate the task execution.
    final message = A2AMessage()
      ..messageId = _uuid.v4()
      ..contextId = contextId
      ..taskId = taskId
      ..role = 'agent'
      ..parts = ([A2ATextPart()..text = 'Hello World']);

    eventBus.publish(message);
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
    helloworldAgentCard,
    taskStore,
    agentExecutor,
    eventBusManager,
    null
  );
  final transportHandler = A2AJsonRpcTransportHandler(requestHandler);

  // Initialise the express app
  final appBuilder = A2AExpressApp(requestHandler, transportHandler);
  final expressApp = appBuilder.setupRoutes(Darto(), '');

  // Start listening
  const port = 9999;
  expressApp.listen(port, () {
    print(
      '${Colorize('[MyAgent] Server using new framework started on http://localhost:$port').blue()}',
    );
    print(
      '${Colorize('[MyAgent] Agent Card: http://localhost:$port}/.well-known/agent-card.json').blue()}',
    );
    print('${Colorize('[MyAgent] Press Ctrl+C to stop the server').blue()}');
  });
}
