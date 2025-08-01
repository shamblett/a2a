/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

import 'dart:io';
import 'dart:async';

import 'package:colorize/colorize.dart';
import 'package:args/args.dart';
import 'package:uuid/uuid.dart';

import 'package:a2a/a2a.dart';

// The client and its base URL
A2AClient? client;
String baseUrl = '';

// Agent name
String agentName = 'Agent'; // Default, try to get from agent card later

// Streaming support
bool agentSupportsStreaming = false;

// State
String currentTaskId = '';
String currentContextId = '';

// Uuid
final uuid = Uuid();

// Utility function to check if the base URL is
// remote or on local host. Note remote means not localhost
// or 127.0.0.1
bool isBaseUrlRemote() {
  if (baseUrl.contains('localhost') || baseUrl.contains('127.0.0.1')) {
    return false;
  }
  return true;
}

// Fetch and display the agent card
Future<void> fetchAnDisplayAgentCard() async {
  // Construct the client, this will fetch the agent card
  try {
    client = A2AClient(baseUrl);
    if (isBaseUrlRemote()) {
      // Delay a little
      await Future.delayed(Duration(seconds: 5));
    }
  } catch (e) {
    print(
      '${Colorize('Fatal error constructing client...please try again')..red()}',
    );
    exit(-1);
  }

  // Get the cached agent card
  try {
    final card = await client!.getAgentCard();
    print('${Colorize('✓ Agent Card Found')..green()}');
    agentName = card.name;
    print('  Agent Name : $agentName');
    if (card.description.isNotEmpty) {
      print('  Description : ${card.description}');
    }
    if (card.version.isNotEmpty) {
      print('  Version : ${card.version}');
    }
    if (card.capabilities.streaming == true) {
      print('${Colorize('  Streaming supported')..green()}');
      agentSupportsStreaming = true;
    } else {
      print(
        '${Colorize('  ❌ Streaming not supported or not specified')..yellow()}',
      );
      print(
        '${Colorize('  Client will fallback to using non streaming API calls')..dark()}',
      );
    }
  } catch (e) {
    print('${Colorize('Error fetching or parsing the agent card')..yellow()}');
    rethrow;
  }
}

// Read a line from the terminal
// Returns an empty string if no line is entered
String readLine() {
  final prompt = Colorize('$agentName > You : ')..cyan();
  print('');
  print(prompt);
  print('');
  final input = stdin.readLineSync();
  if (input == null) {
    return '';
  }
  return input.trim();
}

// Id generator
String generateId() => uuid.v4();

String generateTaskProgress(String prefix, A2ATaskState state) {
  String output;
  switch (state) {
    case A2ATaskState.submitted:
      final stateString = Colorize(state.name)..blue();
      output = '$prefix 🚧 Status : $stateString';
    case A2ATaskState.working:
      final stateString = Colorize(state.name)..blue();
      output = '$prefix ⏳ Status : $stateString ';
    case A2ATaskState.inputRequired:
      final stateString = Colorize(state.name)..yellow();
      output = '$prefix 🤔 Status : $stateString ';
    case A2ATaskState.completed:
      final stateString = Colorize(state.name)..green();
      output = '$prefix ✅ Status : $stateString ';
    case A2ATaskState.canceled:
      final stateString = Colorize(state.name)..darkGray();
      output = '$prefix ⏹️ Status : $stateString ';
    case A2ATaskState.failed:
      final stateString = Colorize(state.name)..red();
      output = '$prefix x Status : $stateString ';
    default:
      final stateString = Colorize(state.name)..dark();
      output = '$prefix ℹ️ Status : $stateString ';
  }
  return output;
}

void printAgentEvent(A2ASendStreamMessageSuccessResponseR event) {
  final timestamp = DateTime.now()
    ..toLocal(); // Get fresh timestamp for each event
  final prefix = Colorize('$agentName $timestamp :')
    ..magenta();
  String output = '';

  if (event.result is A2ATask) {
    final update = event.result as A2ATask;
    final state = update.status?.state;
    output = generateTaskProgress(prefix.toString(), state!);
    output += '(  Task: ${update.id}, Context: ${update.contextId}';
    //String finalString = '';
    //if (update == true) {
    //finalString = ' [FINAL]';
    //}
    print(output);
  } //else if (
}

// Streaming event processor
void processAgentStreamingResponse(A2ASendStreamMessageResponse response) {
  final timestamp = DateTime.now()
    ..toLocal(); // Get fresh timestamp for each event
  final prefix = Colorize('$agentName $timestamp :')
    ..magenta()
    ..toString();

  if (response.isError) {
    final error = response as A2AJSONRPCError;
    print(
      '${Colorize('Streaming response from the agent is an RPC error, code is ${error.code}}')..red()}',
    );
  }
  final event = response as A2ASendStreamMessageSuccessResponseR;
  printAgentEvent(event);
}

// Single message processor
void processAgentResponse(A2ASendStreamingMessageResponse response) {
  print('TODO');
}

// Query the agent
Future<void> queryAgent(String query) async {
  // Construct the parameters
  final messageId = generateId(); // Generate a unique message ID

  // Parameters
  final part = A2ATextPart()..text = query;

  final messagePayload = A2AMessage()
    ..messageId = messageId
    ..role = 'user'
    ..parts = [part];

  // Conditionally add taskId to the message payload
  if (currentTaskId.isNotEmpty) {
    messagePayload.taskId = currentTaskId;
  }

  // Conditionally add contextId to the message payload
  if (currentContextId.isNotEmpty) {
    messagePayload.contextId = currentContextId;
  }

  // Params
  // Optional: configuration for streaming, blocking, etc.
  // configuration: {
  //   acceptedOutputModes: ['text/plain', 'application/json'], // Example
  //   blocking: false // Default for streaming is usually non-blocking
  // }
  final params = A2AMessageSendParams()..message = messagePayload;

  // Send the message, streaming if supported
  try {
    if (agentSupportsStreaming) {
      final events = client?.sendMessageStream(params);
      await for (final event in events!) {
        processAgentStreamingResponse(event);
      }
    } else {
      print('TODO');
    }
  } catch (e) {
    print('Exception received in send message');
    rethrow;
  }
}

/// Simple CLI client application for the A2AClient.
///
/// Usage : a2a_client_cli `<baseUrl>`
/// If no baseUrl is supplied then https://sample-a2a-agent-908687846511.us-central1.run.app
/// will be used,
Future<int> main(List<String> argv) async {
  ArgResults results;

  // Initialize the argument parser and parse the arguments
  final argParser = ArgParser();
  argParser.addFlag('help', abbr: 'h', negatable: false);

  try {
    results = argParser.parse(argv);
  } on FormatException catch (e) {
    print(e.message);
    return -1;
  }

  // Help
  if (results['help']) {
    print('Usage: a2a_cli_client <baseUrl> of the agent');
    print('');
    print(argParser.usage);
    return 0;
  }

  baseUrl = results.rest.isNotEmpty
      ? results.rest.join('')
      : 'https://sample-a2a-agent-908687846511.us-central1.run.app';

  // Announce
  print('');
  print('A2A CLI Client');
  print('${Colorize('Agent Base URL: $baseUrl')..dark()}');

  // Get the agent card
  await fetchAnDisplayAgentCard();

  print('');
  print(
    '${Colorize('No active task or context initially. Use "/new" '
    'to start a fresh session or send a message.')..dark()}',
  );
  print('${Colorize('Enter messages, "/exit" to quit.')..green()}');

  // Read the prompt input
  var line = '';
  while (line != '/exit') {
    line = readLine();
    if (line.isNotEmpty) {
      if (line == '/new') {
        currentTaskId = '';
        currentContextId = '';
        print('Starting new session. Task and Context IDs are cleared.');
      }

      // Send to the agent
      if (line != '/exit') {
        await queryAgent(line);
      }
    }
  }

  print('');
  print('A2A CLI Client exiting');
  return 0;
}
