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
  A2AMCPBridge a2aMcpBridge = A2AMCPBridge();
  try {
    await a2aMcpBridge.startServers();
  } catch (e) {
    print('${Colorize('MCP Bridge failed to start $e').red()}');
    return;
  }
}
