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

  void _initialiseTools() {

  }
}
