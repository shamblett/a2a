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

/// Simple CLI client application for the A2AClient.
///
/// Usage : a2a_client_cli `<baseUrl>`
/// If no baseUrl is supplied then https://sample-a2a-agent-908687846511.us-central1.run.app
/// will be used,
Future<int> main(List<String> argv) async {
  // Parameters
  String baseUrl;

  ArgResults results;

  // Initialize the argument parser
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

  if (results.rest.isNotEmpty) {
    baseUrl = results.rest.join('');
  } else {
    print(
      'A2A CLI Client : Using base URL "https://sample-a2a-agent-908687846511.us-central1.run.app"',
    );
    baseUrl = 'https://sample-a2a-agent-908687846511.us-central1.run.app';
    return 0;
  }

  return 0;
}
