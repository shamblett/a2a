/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

import 'package:a2a/a2a.dart';

/// An example of using the client with the remote agent located at
/// https://sample-a2a-agent-908687846511.us-central1.run.app
/// See the README file in https://github.com/a2aproject/a2a-samples/tree/main/samples/python/hosts/cli
/// for more details for this agent.
///
/// Note some familiarity with the A2A protocol is assumed, what an artifact is, what a task is etc.
///

Future<int> main() async {
  const baseUrl = 'https://sample-a2a-agent-908687846511.us-central1.run.app';

  print('');
  print('A2AClient Example');

  /// Construct the client, needs the base URL of the agent.
  /// This will also prefetch and cache the agents agent card.
  A2AClient? client = A2AClient(baseUrl);

  /// Delay a little to allow the fetch to complete.
  print('');
  print('Awaiting agent card........');
  await Future.delayed(Duration(seconds: 10));

  /// Get the agent card.
  /// If a baseUrl parameter is provided the agent card will be fetched from the agent
  /// at the location specified, otherwise the cached agent card will be returned.
  try {
    final agentCard = await client.getAgentCard();

    /// Print some details of the Agent card
    print('');
    print('Agent card details for the CLI test agent');
    print('');
    print('The agent name is "${agentCard.name}"');
    print('The agent description is "${agentCard.description}"');
    print('The agent version is "${agentCard.version}"');
    final streaming = agentCard.capabilities.streaming! ? 'Yes' : 'No';
    print('Is the agent streaming capable "$streaming"');
    print('Default input modes "${agentCard.defaultInputModes}"');
    print('Default output modes "${agentCard.defaultOutputModes}"');
    print('Service endpoint "${agentCard.url}"');
  } catch (e) {
    print('');
    print(
      'Failed to fetch the agent card, maybe the agent is busy, please try again',
    );
  }

  /// Send a message to the agent to ask it a fact
  const prompt = 'What is the total area of New York state?';

  print('');
  print('Asking the agent "$prompt"');

  /// Build the parameters for the prompt and use the [client.sendMessage] method to
  /// get the response.
  final message = A2AMessage()
    ..role = 'user'
    ..parts = [A2ATextPart()..text = prompt];
  final configuration = A2AMessageSendConfiguration()
    ..acceptedOutputModes = ['text'];
  final payload = A2AMessageSendParams()
    ..message = message
    ..configuration = configuration;

  final rpcResponse = await client.sendMessage(payload);

  /// Check for an error
  if (rpcResponse.isError) {
    final errorResponse = rpcResponse as A2AJSONRPCErrorResponse;
    final code = errorResponse.error?.rpcErrorCode;
    print('');
    print('An error as occurred, the RPC error code is $code');
    print('');
    print('A2AClient Example Complete with error');
    return -1;
  }

  /// No error so we have a success response
  final response = rpcResponse as A2ASendMessageSuccessResponse;

  /// The result is an A2ATask
  final result = response.result as A2ATask;

  /// Get the artifacts
  A2AArtifact artifact;
  if (result.artifacts != null) {
    artifact = result.artifacts!.first;
  } else {
    print('');
    print('No artifacts have been returned by the agent');
    print('');
    print('A2AClient Example Complete with no response');
    return -1;
  }

  /// Get the part, we know its a text part
  final part = artifact.parts.first as A2ATextPart;

  /// Get the textual response
  final text = part.text;

  print('');
  print('The agent has returned the following response ....');
  print('');
  print('--------------->');
  print(text);

  /// Complete
  print('A2AClient Example Complete');

  return 0;
}
