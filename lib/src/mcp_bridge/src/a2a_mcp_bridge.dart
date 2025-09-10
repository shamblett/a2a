/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../a2a_mcp_bridge.dart';

///
/// The A2A MCP Bridge.
///
class A2AMCPBridge {
  final A2AMCPServer _server = A2AMCPServer();

  final List<Tool> _registeredTools = [];

  final Map<String, A2AAgentCard> _registeredAgents = {};

  A2AMCPBridge() {
    // Initialise the tools
    _initialiseTools();
    // Start the servers
    _startServers();
  }

  /// Stop the servers
  Future<void> stopServers() async {
    await _server.close();
  }

  // Register agent callback
  Future<CallToolResult> _registerAgentCallback({
    Map<String, dynamic>? args,
    RequestHandlerExtra? extra,
  }) async {
    if (args == null) {
      print(
        '${Colorize('A2AMCPBridge::_registerAgentCallback - args are null').yellow()}',
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

  // List agents callback
  Future<CallToolResult> _listAgentsCallback({
    Map<String, dynamic>? args,
    RequestHandlerExtra? extra,
  }) async {
    final jsonString = json.encode(_registeredAgents.keys.toList());
    final jsonMap = json.decode(jsonString);
    return CallToolResult.fromContent(content: [Content.fromJson(jsonMap)]);
  }

  void _initialiseTools() {
    // Register agent
    var inputSchema = ToolInputSchema(
      properties: {
        'url': {'type': 'string', 'description': 'The agent URL'},
      },
      required: ['url'],
    );
    var outputSchema = ToolOutputSchema(
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
    _registeredTools.add(registerAgent);
    _server.registerTool(registerAgent, _registerAgentCallback);

    // List Agents
    inputSchema = ToolInputSchema(properties: {});
    outputSchema = ToolOutputSchema(
      properties: {
        'type': 'array',
        'items': {'type': 'string'},
      },
    );

    final listAgents = Tool(
      name: 'list_agents',
      description: 'A2A Bridge List Agents',
      inputSchema: inputSchema,
      outputSchema: outputSchema,
    );
    _registeredTools.add(listAgents);
    _server.registerTool(listAgents, _listAgentsCallback);
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
        '${Colorize('A2AMcpBridge::_fetchAgentCard - failed to fetch agent card for $fetchUrl').yellow()}',
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

  // Start the servers
  Future<void> _startServers() async {
    await _server.start();
  }
}
