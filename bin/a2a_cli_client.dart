/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

import 'dart:async';

import 'package:args/args.dart';
import 'package:colorize/colorize.dart';
import 'package:a2a/a2a.dart';

/// Simple CLI client application for the A2AClient.
///
/// Usage : a2a_client_cli `<baseUrl>`
/// If no baseUrl is supplied then https://sample-a2a-agent-908687846511.us-central1.run.app
/// will be used,
Future<int> main(List<String> argv) async {
  ArgResults results;

  // Initialize the argument parser and parse the arguments
  final argParser = ArgParser();
  argParser.addFlag(
    'no-streaming',
    abbr: 's',
    help: 'Do not use streaming API calls even if the agent supports streaming',
    negatable: false,
  );
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

  // No streaming
  if (results['no-streaming']) {
    A2ACLIClientSupport.noStreaming = true;
  }

  A2ACLIClientSupport.baseUrl = results.rest.isNotEmpty
      ? results.rest.join('')
      : 'https://sample-a2a-agent-908687846511.us-central1.run.app';

  // Announce
  print('');
  print('A2A CLI Client');
  print(
    '${Colorize('Agent Base URL: ${A2ACLIClientSupport.baseUrl}')..dark()}',
  );

  // Get the agent card
  await A2ACLIClientSupport.fetchAnDisplayAgentCard();

  print('');
  print(
    '${Colorize('No active task or context initially. Use "/new" '
    'to start a fresh session, /resub to resubscribe to an interrupted'
    'streaming request or send a message at the prompt.')..dark()}',
  );
  print('${Colorize('Enter messages, "/exit" to quit.')..green()}');

  // Read the prompt input
  var line = '';
  while (line != '/exit') {
    line = A2ACLIClientSupport.readLine();
    if (line.isNotEmpty) {
      if (line == '/new') {
        A2ACLIClientSupport.currentTaskId = '';
        A2ACLIClientSupport.currentContextId = '';
        print('Starting new session. Task and Context IDs are cleared.');
        continue;
      }

      if (line == '/resub') {
        await A2ACLIClientSupport.queryAgentResub();
        continue;
      }

      // Send to the agent
      if (line != '/exit') {
        await A2ACLIClientSupport.queryAgent(line);
        continue;
      }
    }
  }

  print('');
  print('A2A CLI Client exiting');
  return 0;
}
