/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../a2a_mcp_bridge.dart';

class AuthProvider implements OAuthClientProvider {
  /// Get current tokens if available
  @override
  Future<OAuthTokens?> tokens() async => OAuthTokens(
    accessToken: Platform.environment['DART_MCP_API_KEY']!,
    refreshToken: Platform.environment['DART_MCP_API_KEY']!,
  );

  /// Redirect to authorization endpoint
  @override
  Future<void> redirectToAuthorization() async {
    return;
  }
}

void main() async {
  final implementation = Implementation(
    name: 'A2A Dart MCP Client',
    version: '1.0.0',
  );
  final options = ClientOptions();
  final client = Client(implementation, options: options);

  final serverUrl = Uri.parse('https://mcp.dartai.com/mcp');
  final serverOptions = StreamableHttpClientTransportOptions(
    sessionId: 'Dart A2A Client',
    authProvider: AuthProvider(),
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

  print('Server Version');
  final serverVersion = client.getServerVersion();
  print('Server Version - $serverVersion');

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
