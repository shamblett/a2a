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
/// The server starts on http://localhost:3080/mcp by default, the port can be changed.
/// To see the server details now run the mcp/a2a_query_mcp_server.dart example -
///
///   'dart example/mcp/a2a_query_mcp_server.dart localhost:3080/mcp'
///
Future<void> main() async {
  // Create and start the bridge
  print('${Colorize('Creating MCP Bridge').blue()}');
  A2AMCPBridge a2aMcpBridge = A2AMCPBridge();
  try {
    await a2aMcpBridge
        .startServer(); // Set your port if you do not want the default
  } catch (e) {
    print('${Colorize('MCP Bridge failed to start $e').red()}');
    return;
  }
}
