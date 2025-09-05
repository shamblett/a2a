/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../a2a_mcp_bridge.dart';

void main() async {
  final implementation = Implementation(
    name: 'A2A Dart MCP Client',
    version: '1.0.0',
  );
  final options = ClientOptions();
  final client = Client(implementation, options: options);

  final serverOptions = StdioServerParameters(
    command: '/home/steve/Development/idea-IC-243.24978.46/jbr/bin/java',
    args: [
      '--classpath',
      '/home/steve/Development/idea-IC-243.24978.46/plugins/mcpserver/lib/mcpserver-frontend.jar:/home/steve/Development/idea-IC-243.24978.46/lib/util-8.jar',
      'com.intellij.mcpserver.stdio.McpStdioRunnerKt',
    ],
    environment: {'IJ_MCP_SERVER_PORT': '64342'},
  );
  final clientTransport = StdioClientTransport(serverOptions);

  try {
    await client.connect(clientTransport);
  } catch (e) {
    print('${Colorize('Exception thrown - $e').red()}');
  }

  final instructions = client.getInstructions();
  print(instructions);

  final serverVersion = client.getServerVersion();
  print(serverVersion);
}

// {
// "type": "stdio",
// "env": {
// "IJ_MCP_SERVER_PORT": "64342"
// },
// "command": "/home/steve/Development/idea-IC-243.24978.46/jbr/bin/java",
// "args": [
// "-classpath",
// "/home/steve/Development/idea-IC-243.24978.46/plugins/mcpserver/lib/mcpserver-frontend.jar:/home/steve/Development/idea-IC-243.24978.46/lib/util-8.jar",
// "com.intellij.mcpserver.stdio.McpStdioRunnerKt"
// ]
// }