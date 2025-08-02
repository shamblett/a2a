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

void printMessageContent(A2AMessage? message) {
  int index = 0;
  if (message == null) {
    print('${Colorize('Cannot print message, message is null').yellow}');
    return;
  }
  if (message.parts != null) {
    final partPrefix = '${Colorize('Part ${index + 1}:')..red()}';
    for (final part in message.parts!) {
      if (part is A2ATextPart) {
        print('$partPrefix ${Colorize('📝 Text:')..green()}, ${part.text}');
      } else if (part is A2AFilePart) {
        String name = '';
        String mimeType = '';
        String variant = '';
        if (part.file is A2AFileWithBytes) {
          final tmp = part.file as A2AFileWithBytes;
          name = tmp.name;
          mimeType = tmp.mimeType;
          variant = 'Inline Bytes';
        } else {
          if (part.file is A2AFileWithUri) {
            final tmp = part.file as A2AFileWithUri;
            name = tmp.name;
            mimeType = 'N/A';
            variant = tmp.uri;
          }
        }
        print(
          '$partPrefix ${Colorize('📄 File:')..blue()}, Name: $name, Type: $mimeType, Source: $variant',
        );
      } else if (part is A2ADataPart) {
        print('$partPrefix ${Colorize('📊 Data: ')..yellow()}, $part.data');
      }
    }
  } else {
    print('${Colorize('No parts in message').yellow}');
  }
}

void commonPrintHandling(Object event) {
  final timestamp = DateTime.now()
    ..toLocal(); // Get fresh timestamp for each event
  final prefix = Colorize('$agentName $timestamp :')..magenta();
  String output = '';

  if (event is A2ATask) {
    final update = event;
    final state = update.status?.state;
    print('${prefix.toString()} ${Colorize('Task Stream Event').blue()}');
    if (update.id != currentTaskId) {
      print(
        '${Colorize('Task ID updated from $currentTaskId to ${update.id}')..dark()}',
      );
      currentTaskId = update.id;
    }
    if (update.contextId != currentContextId) {
      print(
        '${Colorize('Context ID updated from $currentContextId to ${update.contextId}')..dark()}',
      );
      currentContextId = update.contextId;
    }
    if (update.status?.message != null) {
      print('${Colorize('   Task includes message:')..darkGray()}');
      printMessageContent(update.status?.message);
    }
    if (update.artifacts != null && update.artifacts?.isNotEmpty == true) {
      print('${Colorize('   Task includes artifacts:')..darkGray()}');
    }
    output = generateTaskProgress(prefix.toString(), state!);
    output += '(  Task: ${update.id}, Context: ${update.contextId}';
    print(output);
  } else if (event is A2ATaskStatusUpdateEvent) {
    final update = event;
    final state = update.status?.state;

    // If the event is a TaskStatusUpdateEvent and it's final, reset currentTaskId and
    // context id
    if (update.end == true) {
      currentContextId = '';
      currentTaskId = '';
      print(
        '${Colorize('Task ${update.taskId} is FINAL. Clearing current task ID.')..yellow()}',
      );
    }
    output = generateTaskProgress(prefix.toString(), state!);
    output += '(  Task: ${update.taskId}, Context: ${update.contextId}';
    print(output);
  } else if (event is A2ATaskArtifactUpdateEvent) {
    final update = event;
    print(
      '${Colorize('Task artifact update event received for task $update.taskId')..yellow()}',
    );
  } else if (event is A2AMessage) {
    final update = event;
    print(
      '${prefix.toString()} ${Colorize('✉️ Message Stream Event:')..green()}',
    );
    printMessageContent(update);
    if (update.taskId != currentTaskId) {
      print(
        '${Colorize('Task ID updated from $currentTaskId to ${update.taskId} from message event')..dark()}',
      );
      currentTaskId = update.taskId!;
    }
    if (update.contextId != currentContextId) {
      print(
        '${Colorize('Context ID updated from $currentContextId to ${update.contextId} from message event')..dark()}',
      );
      currentContextId = update.contextId!;
    }
  } else {
    print(
      '${Colorize('Received unknown event structure from stream: $event')..yellow()}',
    );
  }
}

void printAgentEventStreaming(A2ASendStreamMessageSuccessResponseR event) {
  if (event.result != null) {
    commonPrintHandling(event.result!);
  } else {
    print('${Colorize('Null result returned by agent')..red()}');
  }
}

void printAgentEvent(A2ASendMessageSuccessResponse event) {
  if (event.result != null) {
    commonPrintHandling(event.result!);
  } else {
    print('${Colorize('Null result returned by agent')..red()}');
  }
}

// Streaming event processor
void processAgentStreamingResponse(A2ASendStreamMessageResponse response) {
  // Check for error
  if (response.isError) {
    final error = response as A2AJSONRPCError;
    print(
      '${Colorize('Streaming response from the agent is an RPC error, code is ${error.code}}')..red()}',
    );
    return;
  }

  // Process the response
  final event = response as A2ASendStreamMessageSuccessResponseR;
  printAgentEventStreaming(event);
}

// Single message processor
void processAgentResponse(A2ASendMessageResponse response) {
  // Check for an error
  if (response.isError) {
    final error = response as A2AJSONRPCErrorResponseS;
    print(
      '${Colorize('RPC error returned from send message, code is ${error.error?.rpcErrorCode}')..red()}',
    );
    return;
  }

  // Process the response
  final event = response as A2ASendMessageSuccessResponse;
  printAgentEvent(event);
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
    if (!agentSupportsStreaming) {
      final events = client?.sendMessageStream(params);
      await for (final event in events!) {
        processAgentStreamingResponse(event);
      }
    } else {
      // Fallback to send message
      final response = await client?.sendMessage(params);
      if (response != null) {
        processAgentResponse(response);
      } else {
        print('${Colorize('Response from send message is null')..red()}');
      }
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
