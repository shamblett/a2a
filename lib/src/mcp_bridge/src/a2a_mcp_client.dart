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

  final serverUrl = Uri.dataFromString('https://mcp.dartai.com/mcp');
  final serverOptions = StreamableHttpClientTransportOptions(
    sessionId: 'Dart A2A Client',
  );
  final clientTransport = StreamableHttpClientTransport(
    serverUrl,
    opts: serverOptions,
  );

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