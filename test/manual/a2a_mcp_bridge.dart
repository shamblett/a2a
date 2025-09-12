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
  test('Server Version', () async {
    await client.connect(clientTransport);
    final serverVersion = client.getServerVersion();
    expect(serverVersion, isNotNull);
    expect(serverVersion?.name, 'A2A MCP Bridge Server');
    expect(serverVersion?.version, '1.0.0');
    await clientTransport.close();
    await client.close();
  });
}
