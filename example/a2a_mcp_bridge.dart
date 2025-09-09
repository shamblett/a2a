/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

import 'package:colorize/colorize.dart';
import 'package:uuid/uuid.dart';

import 'package:a2a/a2a.dart';

///
/// An example showing usage of the MCP to A2A bridge.
///

Future<void> main() async {
  // Create and start the server using defaults
  print('${Colorize('Creating MCP server and connecting...').blue()}');
  final mcpServer = A2AMCPServer();

  try {
    await mcpServer.connect();
  } catch (e) {
    print('${Colorize('MCP server failed to connect $e').red()}');
    return;
  }

  // Delay and close
  print('${Colorize('MCP server connected, delaying...').blue()}');
  await Future.delayed(Duration(seconds: 60));

  print('${Colorize('Closing').blue()}');
  await mcpServer.close();
}
