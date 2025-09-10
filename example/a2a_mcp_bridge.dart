/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

import 'package:colorize/colorize.dart';

import 'package:a2a/a2a.dart';

///
/// An example showing usage of the MCP to A2A bridge.
///

Future<void> main() async {
  // Create and start the bridge
  print('${Colorize('Creating MCP Bridge').blue()}');
  A2AMCPBridge a2aMcpBridge;
  try {
    a2aMcpBridge = A2AMCPBridge();
  } catch (e) {
    print('${Colorize('MCP Bridge failed to start $e').red()}');
    return;
  }

  // Delay and close
  print('${Colorize('delaying...').blue()}');
  await Future.delayed(Duration(seconds: 60));

  print('${Colorize('Closing Bridge').blue()}');
  await a2aMcpBridge.stopServers();

  await Future.delayed(Duration(seconds: 1));
  print('${Colorize('Exiting').blue()}');
}
