// ignore_for_file: prefer_single_quotes

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
  final A2AMCPServer _mcpServer = A2AMCPServer();

  final List<Tool> _registeredTools = [];

  final Map<String, A2AAgentCard> _registeredAgents = {};

  final Map<String, String> _agentLookup = {};

  A2AMCPBridge() {
    // Initialise the tools
    _initialiseTools();
  }

  /// Start the servers
  Future<void> startServers() async {
    await _mcpServer.start();
  }

  /// Stop the servers
  Future<void> stopServers() async {
    await _mcpServer.close();
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
    _agentLookup[args['url']] = agentCard.name;
    final content = {"status": "success", "agentname": "$agentCard.name"};
    return CallToolResult.fromContent(content: [Content.fromJson(content)]);
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

  // Unregister agent callback
  Future<CallToolResult> _unregisterAgentCallback({
    Map<String, dynamic>? args,
    RequestHandlerExtra? extra,
  }) async {
    if (args == null) {
      print(
        '${Colorize('A2AMCPBridge::_unregisterAgentCallback - args are null').yellow()}',
      );
      return CallToolResult.fromContent(
        content: [UnknownContent(type: 'unknown')],
        isError: true,
      );
    }
    final url = args['url'];
    if (!_agentLookup.containsKey(url)) {
      // Agent not registered
      return CallToolResult.fromContent(
        content: [TextContent(text: 'Agent is not Registered')],
        isError: true,
      );
    }

    _registeredAgents.remove(_agentLookup[url]);
    _agentLookup.remove(url);

    // TODO Clean up any task mappings related to this agent
    // Create  a list of task_ids to remove to avoid modifying the dictionary during iteration
    final content = {"status": "success"};
    return CallToolResult.fromContent(content: [Content.fromJson(content)]);
  }

  // Send message callback
  Future<CallToolResult> _sendMessageCallback({
    Map<String, dynamic>? args,
    RequestHandlerExtra? extra,
  }) async {
    if (args == null) {
      print(
        '${Colorize('A2AMCPBridge::_sendMessageCallback - args are null')
            .yellow()}',
      );
      return CallToolResult.fromContent(
        content: [UnknownContent(type: 'unknown')],
        isError: true,
      );
    }


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
    _mcpServer.registerTool(registerAgent, _registerAgentCallback);

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
    _mcpServer.registerTool(listAgents, _listAgentsCallback);

    // Unregister agent
    inputSchema = ToolInputSchema(
      properties: {
        'url': {'type': 'string', 'description': 'The agent URL'},
      },
      required: ['url'],
    );
    outputSchema = ToolOutputSchema(
      properties: {
        'status': {'type': 'string'},
        'message': {'type': 'string'},
      },
    );
    final unRegisterAgent = Tool(
      name: 'unregister_agent',
      description: 'A2A Bridge Unregister Agent',
      inputSchema: inputSchema,
      outputSchema: outputSchema,
    );
    _registeredTools.add(unRegisterAgent);
    _mcpServer.registerTool(unRegisterAgent, _unregisterAgentCallback);

    // Send Message
    inputSchema = ToolInputSchema(
      properties: {
        'url': {'type': 'string', 'description': 'The agent URL'},
        'message' :  {'type': 'string', 'description': 'Message to send to the agent'},
        'session_id' : {'type': 'string', 'description': 'Multi conversation session id'},
      },
      required: ['url', 'message'],
    );
    outputSchema = ToolOutputSchema(
      properties: {
        'task_id': {'type': 'string'},
        'response': {'type': 'string'},
      },
    );
    final sendMessage = Tool(
      name: 'send_message',
      description: 'A2A Bridge Send Message to an Agent',
      inputSchema: inputSchema,
      outputSchema: outputSchema,
    );
    _registeredTools.add(sendMessage);
    _mcpServer.registerTool(sendMessage, _sendMessageCallback);
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
}
