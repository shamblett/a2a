// ignore_for_file: member-ordering

/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../a2a_mcp_bridge.dart';

///
/// Provides an MCP server with a set of predefined tools for use
/// by the [A2AMCPBridge] class.
///
class A2AMCPServer {
  static const serverName = 'A2A MCP Bridge Server';
  static const serverVersion = '1.0.0';
  static const defaultServerPort = 3080;
  static const defaultUrl = 'http://localhost:$defaultServerPort';

  /// The url of the server
  String url = defaultUrl;

  /// The name of the server
  String name = serverName;

  /// The version of the server
  String version = serverVersion;

  /// The transport to use, always [StreamableHttpClientTransport]
  StreamableHTTPServerTransport? transport;

  static Implementation _implementation = Implementation(
    name: serverName,
    version: serverVersion,
  );

  HttpServer? _httpServer;

  McpServer _server = McpServer(_implementation); // Default

  /// Construction
  A2AMCPServer() {
    _implementation = Implementation(name: name, version: version);
    _server = McpServer(_implementation);
    final serverCapabilities = ServerCapabilities(
      tools: ServerCapabilitiesTools(listChanged: false),
    );
    final serverOptions = ServerOptions(
      capabilities: serverCapabilities,
      instructions: 'For use only by the A2A MCP Bridge',
    );
    _server = McpServer(_implementation, options: serverOptions);

    // Create the transport if not set by the user, stateless transport
    transport ??= StreamableHTTPServerTransport(
      options: StreamableHTTPServerTransportOptions(
        sessionIdGenerator: () => null,
      ),
    );
  }

  /// Start the server
  Future<void> start({int port = defaultServerPort}) async {
    if (transport == null) {
      throw StateError('A2AMCPServer::start - cannot start, transport is null');
    }
    // Connect the transport
    await _server.connect(transport!);

    // Resolve IPV4 localhost
    InternetAddress? host;
    final resolutions = await InternetAddress.lookup('localhost');
    for (final resolution in resolutions) {
      if (resolution.type == InternetAddressType.IPv4) {
        host = resolution;
      }
    }
    if (host == null) {
      throw StateError(
        'A2AMCPServer::start - cannot start, unable to resolve IPV4 address for localhost',
      );
    }

    // Start the HTTTServer
    _httpServer = await HttpServer.bind(host, port);
    print(
      '${Colorize('A2AMcpServer: - MCP Streamable HTTP Server listening on port $port').blue()}',
    );
    _httpServer?.listen((request) async {
      if (request.uri.path == '/mcp') {
        await transport?.handleRequest(request);
      }
    });
  }

  /// Close
  Future<void> close() async {
    await _server.close();
    await _httpServer?.close(force: true);
  }

  /// Register a tool
  void registerTool(Tool tool, ToolCallback callback) {
    _server.tool(
      tool.name,
      description: tool.description,
      toolInputSchema: tool.inputSchema,
      toolOutputSchema: tool.outputSchema,
      callback: callback,
    );
  }
}
