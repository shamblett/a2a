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
  static const defaultServerPort = 41243;
  static const defaultUrl = 'http://localhost:$defaultServerPort';

  /// The url of the server
  String url = defaultUrl;

  /// The transport to use, always [StreamableHttpClientTransport]
  StreamableHTTPServerTransport? transport;

  static final _implementation = Implementation(
    name: serverName,
    version: serverVersion,
  );

  HttpServer? _httpServer;

  McpServer _server = McpServer(_implementation); // Default

  final List<Tool> _tools = [];

  final Map<String, A2AAgentCard> _registeredAgents = {};

  /// Get a registered agent by its name
  A2AAgentCard? registeredAgentByName(String name) {
    if (_registeredAgents.containsKey(name)) {
      return _registeredAgents[name];
    }
    return null;
  }

  /// All registered agents
  Map<String, A2AAgentCard> get allRegisteredAgents => _registeredAgents;

  /// Construction
  A2AMCPServer() {
    final serverCapabilities = ServerCapabilities(
      tools: ServerCapabilitiesTools(listChanged: false),
    );
    final serverOptions = ServerOptions(
      capabilities: serverCapabilities,
      instructions: 'For use only by the A2A MCP Bridge',
    );
    _server = McpServer(_implementation, options: serverOptions);
    // Initialise the tools
    _initialiseTools();
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
      '${Colorize('A2AMcpServer: - MCP Streamable HTTP Server listening on port $defaultServerPort').blue()}',
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

  // Register agent callback
  Future<CallToolResult> _registerAgentCallback({
    Map<String, dynamic>? args,
    RequestHandlerExtra? extra,
  }) async {
    if (args == null) {
      print(
        '${Colorize('A2AMcpServer::_registerAgentCallback - args are null').yellow()}',
      );
      return CallToolResult.fromContent(
        content: [UnknownContent(type: 'unknown')],
        isError: true,
      );
    }
    final agentCard = await _fetchAgentCard(args['url']);
    if (agentCard.name.isEmpty) {
      print(
        '${Colorize('A2AMcpServer::_registerAgentCallback - agent has no name in agent card').yellow()}',
      );
      return CallToolResult.fromContent(
        content: [UnknownContent(type: 'unknown')],
        isError: true,
      );
    }
    _registeredAgents[agentCard.name] = agentCard;
    return CallToolResult.fromContent(
      content: [
        TextContent(text: 'success'),
        TextContent(text: agentCard.name),
      ],
    );
  }

  void _initialiseTools() {
    // Register agent
    final inputSchema = ToolInputSchema(
      properties: {
        'url': {'type': 'string', 'description': 'The agent URL'},
      },
      required: ['url'],
    );
    final outputSchema = ToolOutputSchema(
      properties: {
        'status': {'type': 'string'},
        'agentName': {'type': 'string'},
      },
    );
    final registerAgent = Tool(
      name: 'register_agent',
      description: 'A2A Bridge Register Agent',
      inputSchema: inputSchema,
      outputSchema: outputSchema,
    );
    _tools.add(registerAgent);
    _server.tool(
      registerAgent.name,
      description: registerAgent.description,
      toolInputSchema: registerAgent.inputSchema,
      toolOutputSchema: registerAgent.outputSchema,
      callback: _registerAgentCallback,
    );
  }

  // Fetch an agent card, if not found use a dummy one.
  Future<A2AAgentCard> _fetchAgentCard(String url) async {
    String fetchUrl = url;
    // Check if the URL already contains the agent path
    if (!url.contains(A2AConstants.agentCardPath)) {
      fetchUrl = '$url\\${A2AConstants.agentCardPath}';
    }
    A2AAgentCard agentCard;
    final response = await http.fetch(
      fetchUrl,
      headers: http.Headers()..append('Accept', 'application/json'),
    );
    if (!response.ok) {
      print(
        '${Colorize('A2AMcpServer::_fetchAgentCard - failed to fetch agent card for $fetchUrl').yellow()}',
      );
      agentCard = A2AAgentCard()
        ..name = 'Unknown'
        ..description = 'Failed to fetch'
        ..url = fetchUrl;
    } else {
      final agentCardJson = await response.json();
      agentCard = A2AAgentCard.fromJson(agentCardJson);
    }

    return agentCard;
  }
}
