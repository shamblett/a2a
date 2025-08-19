/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

import 'package:colorize/colorize.dart';
import 'package:a2a/a2a.dart';

/// A fully annotated example of how to construct an A2A Agent
/// using the Server SDK.

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
  final Set<String> _canceledTasks = {};

  @override
  Future<void> cancelTask(String taskId, A2AExecutionEventBus eventBus) async =>
      _canceledTasks.add(taskId);
  // The execute loop is responsible for publishing the final state

  @override
  Future<void> execute(
    A2ARequestContext requestContext,
    A2AExecutionEventBus eventBus,
  ) async {


  }
}
