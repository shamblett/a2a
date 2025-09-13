@TestOn('vm')
library;

import 'package:test/test.dart';

import 'package:mcp_dart/mcp_dart.dart';

class AuthProvider implements OAuthClientProvider {
  /// Get current tokens if available
  @override
  Future<OAuthTokens?> tokens() async =>
      OAuthTokens(accessToken: '', refreshToken: '');

  /// Redirect to authorization endpoint
  @override
  Future<void> redirectToAuthorization() async {
    return;
  }
}

final implementation = Implementation(
  name: 'A2A MCP Bridge Manual Test',
  version: '1.0.0',
);
final options = ClientOptions();
final client = Client(implementation, options: options);

final serverUrl = Uri.parse('http://localhost:3080/mcp');
final serverOptions = StreamableHttpClientTransportOptions(
  authProvider: AuthProvider(),
);
final clientTransport = StreamableHttpClientTransport(
  serverUrl,
  opts: serverOptions,
);

Future<void> main() async {
  // Start the client
  await client.connect(clientTransport);

  test('Server Version', () async {
    final serverVersion = client.getServerVersion();
    expect(serverVersion, isNotNull);
    expect(serverVersion?.name, 'A2A MCP Bridge Server');
    expect(serverVersion?.version, '1.0.0');
  });
  test('List Tools', () async {
    final tools = await client.listTools();
    expect(tools.tools.length, 6);
    expect(tools.tools.first.name, 'register_agent');
    expect(tools.tools[1].name, 'list_agents');
    expect(tools.tools[2].name, 'unregister_agent');
    expect(tools.tools[3].name, 'send_message');
    expect(tools.tools[4].name, 'get_task_result');
    expect(tools.tools.last.name, 'cancel_task');
  });
  test('List Agents', () async {
    final params = CallToolRequestParams(name: 'list_agents');
    final result = await client.callTool(params);
    expect(result.isError, isNull);
    final content = result.structuredContent;
    expect(content.length, 1);
    expect(content['result'], []);
  });
}
