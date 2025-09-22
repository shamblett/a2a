/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

///
/// A2A MCP Bridge server - [A2AMCPBridge]
///
/// Serves as an MCP bridge between the Model Context Protocol (MCP) and the Agent-to-Agent (A2A) protocol,
/// enabling MCP-compatible AI assistants (like Claude, Gemini etc.) to seamlessly interact with A2A agents.
///
///  Tools and parameters provided :-
///
///    - cancel_task:
///         A2A Bridge cancel an active Agent task
///       Parameters:
///         {
///           "type": "object",
///           "properties": {
///             "task_id": {
///               "type": "string",
///               "description": "The task id"
///             }
///           },
///           "required": [
///             "task_id"
///           ]
///         }
///     - get_task_result:
///         A2A Bridge retrieves a task result from an Agent
///       Parameters:
///         {
///           "type": "object",
///           "properties": {
///             "task_id": {
///               "type": "string",
///               "description": "The Task id"
///             }
///           },
///           "required": [
///             "task_id"
///           ]
///         }
///     - list_agents:
///         A2A Bridge List Agents
///       Parameters:
///         {
///           "type": "object",
///           "properties": {}
///         }
///     - register_agent:
///         A2A Bridge Register Agent
///       Parameters:
///         {
///           "type": "object",
///           "properties": {
///             "url": {
///               "type": "string",
///               "description": "The agent URL"
///             }
///           },
///           "required": [
///             "url"
///           ]
///         }
///     - send_message:
///         A2A Bridge Send Message to an Agent
///       Parameters:
///         {
///           "type": "object",
///           "properties": {
///             "url": {
///               "type": "string",
///               "description": "The Agent URL"
///             },
///             "message": {
///               "type": "string",
///               "description": "Message to send to the agent"
///             },
///             "session_id": {
///               "type": "string",
///               "description": "Multi conversation session id"
///             }
///           },
///           "required": [
///             "url",
///             "message"
///           ]
///         }
///     - unregister_agent:
///         A2A Bridge Unregister Agent
///       Parameters:
///         {
///           "type": "object",
///           "properties": {
///             "url": {
///               "type": "string",
///               "description": "The Agent URL"
///             }
///           },
///           "required": [
///             "url"
///           ]
///         }
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:colorize/colorize.dart';
import 'package:mcp_dart/mcp_dart.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import '../client/a2a_client.dart';
import '../types/a2a_types.dart';

part 'src/a2a_mcp_server.dart';
part 'src/a2a_mcp_bridge.dart';
