/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/


import 'package:colorize/colorize.dart';
import 'package:a2a/a2a.dart';

Future<int> main() async {
  const baseUrl = 'http://localhost:41242';

  /// Construct the client, needs the base URL of the agent.
  /// This will also prefetch and cache the agents agent card.
  A2AClient? client = A2AClient(
    baseUrl,
    'http://localhost:41242/.well-known/agent-card.json',
  );

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
    ..acceptedOutputModes = ['text', 'text/event-stream']
    ..blocking = true;

  final payload = A2AMessageSendParams()
    ..message = message
    ..configuration = configuration;

  final Stream<A2ASendStreamMessageResponse> rpcResponse = await client
      .sendMessageStream(payload);
  // final rpcResponse = await client.sendMessage(payload);

  late final StreamSubscription<A2ASendStreamMessageResponse> subscription;
  subscription = rpcResponse.listen(
        (A2ASendStreamMessageResponse data) {
      if (data.isError) {
        final errorResponse = rpcResponse as A2AJSONRPCErrorResponseS;
        final code = errorResponse.error?.rpcErrorCode;
        print('');
        print(
          '${('An error has occurred, the RPC error code is $code, ${A2AError.asString(code!)}')}',
        );
        print('');
        print('A2AClient Example Complete with error');
        return;
      }

      final response = data as A2ASendStreamMessageSuccessResponse;
      final result = response.result as A2ATask;
      print('!!!! Received response part: ${result.artifacts}');

      print(result.toJson());
    },
    onError: (error) {
      print('!!!! Received error: $error');
    },
    onDone: () {
      subscription.cancel();
      print('!!!! Stream is done.');
    },
    cancelOnError: true, // Optional: cancels subscription on error
  );
}