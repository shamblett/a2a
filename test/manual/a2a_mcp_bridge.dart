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

Future<void> main() async {
  final implementation = Implementation(
    name: 'A2A MCP Bridge Manual Test',
    version: '1.0.0',
  );
  final options = ClientOptions();
  final client = Client(implementation, options: options);

  final serverUrl = Uri.parse('http://localhost:3000');
  final serverOptions = StreamableHttpClientTransportOptions(
    //sessionId: 'A2A-MCP-Query',
    authProvider: AuthProvider(),
  );
  final clientTransport = StreamableHttpClientTransport(
    serverUrl,
    opts: serverOptions,
  );

  test('Server ', () async {
    await client.connect(clientTransport);
    final serverVersion = client.getServerVersion();
    expect(serverVersion, isNotNull);
    expect(serverVersion?.name, 'A2A MCP Bridge Server');
    expect(serverVersion?.version, '1.0.0');
    await client.close();
  });
}
