/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:colorize/colorize.dart';
import 'package:args/args.dart';
import 'package:uuid/uuid.dart';

import 'package:a2a/a2a.dart';

// The client and its base URL
A2AClient? client;
String baseUrl = '';

// Agent name
String agentName = 'Agent'; // Default, try to get from agent card later

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
    } else {
      print(
        '${Colorize('  ❌ Streaming not supported or not specified')..yellow()}',
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
  final prompt = Colorize('You : ')..cyan();
  print(prompt);
  final input = stdin.readLineSync();
  if (input == null) {
    return '';
  }
  return input;
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

  // State
  String currentTaskId = '';
  String currentContextId = '';

  // Announce
  print('');
  print('A2A CLI Client');
  print('${Colorize('Agent Base URL: $baseUrl')..dark()}');

  // Get the agent card
  await fetchAnDisplayAgentCard();

  return 0;
}
