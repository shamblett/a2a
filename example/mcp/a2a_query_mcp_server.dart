/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

import 'dart:io';

import 'package:colorize/colorize.dart';
import 'package:mcp_dart/mcp_dart.dart';

///
/// This example connects to an MCP server and gets its details such as server version,
/// capabilities, resources, prompts etc.
///
/// If your MCP server needs an authentication token set this in the MCP_API_KEY
/// environment variable.
///
/// The first parameter to the script should be the URL Of your MCP server.
///
///
String getAPIKey() {
  final env = Platform.environment;
  if (env.containsKey('MCP_API_KEY')) {
    return env['MCP_API_KEY'] != null ? env['MCP_API_KEY']! : '';
  }
  return '';
}

class AuthProvider implements OAuthClientProvider {
  /// Get current tokens if available
  @override
  Future<OAuthTokens?> tokens() async =>
      OAuthTokens(accessToken: getAPIKey(), refreshToken: getAPIKey());

  /// Redirect to authorization endpoint
  @override
  Future<void> redirectToAuthorization() async {
    return;
  }
}

void main(List<String> args) async {
  final implementation = Implementation(
    name: 'A2A MCP Query Example',
    version: '1.0.0',
  );
  final options = ClientOptions();
  final client = Client(implementation, options: options);

  final serverUrl = Uri.parse(args[0]);
  final serverOptions = StreamableHttpClientTransportOptions(
    sessionId: 'A2A-MCP-Query',
    authProvider: AuthProvider(),
  );
  final clientTransport = StreamableHttpClientTransport(
    serverUrl,
    opts: serverOptions,
  );

  print('Connecting to ${args[0]}');
  try {
    await client.connect(clientTransport);
  } catch (e) {
    print('${Colorize('Exception thrown - $e').red()}');
  }

  print('');
  print('Server Version');
  final serverVersion = client.getServerVersion();
  serverVersion == null
      ? print('${Colorize('<No Server Version supplied>').yellow()}')
      : print('${Colorize('Server version - $serverVersion').blue()}');

  print('');
  print('Server Capabilities');
  final capabilities = client.getServerCapabilities();
  print('${capabilities?.toJson()}');

  print('Resources');
  final resources = await client.listResources();
  for (final resource in resources.resources) {
    print('Resource - ${resource.description}');
  }

  print('Prompts');
  final prompts = await client.listPrompts();
  for (final prompt in prompts.prompts) {
    print('Prompt - ${prompt.description}');
  }

  print('Resource Templates');
  final templates = await client.listResourceTemplates();
  for (final template in templates.resourceTemplates) {
    print('Template - ${template.description}');
  }

  print('Tools');
  final tools = await client.listTools();
  for (final tool in tools.tools) {
    print('Tool - ${tool.name}');
  }
}
