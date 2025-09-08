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

  static final _implementation = Implementation(
    name: serverName,
    version: serverVersion,
  );

  McpServer _server = McpServer(_implementation); // Default

  final List<Tool> _tools = [];

  A2AMCPServer() {
    final serverCapabilities = ServerCapabilities(
      tools: ServerCapabilitiesTools(listChanged: false),
    );
    final serverOptions = ServerOptions(
      capabilities: serverCapabilities,
      instructions: 'For use ony by the A2A MCP Bridge',
    );
    _server = McpServer(_implementation, options: serverOptions);
    _initialiseTools();
  }

  // Register agent callback
  final ToolCallback _registerAgentCallback = (({args, extra}) async {});

  void _initialiseTools() {
    // Register agent
    final inputSchema = ToolInputSchema(
      properties: {'url': 'String'},
      required: ['url'],
    );
    final outputSchema = ToolOutputSchema(
      properties: {'status': 'String', 'agentName': 'String'},
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
}
