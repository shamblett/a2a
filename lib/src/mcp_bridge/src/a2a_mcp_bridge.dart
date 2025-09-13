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

  // Tools registered with the MCP server
  final List<Tool> _registeredTools = [];

  // Registered agents by name.
  final Map<String, A2AAgentCard> _registeredAgents = {};

  // Agent lookup from url to name.
  final Map<String, String> _agentLookup = {};

  // Task to agent mapping
  // Task ids are unique UUID's so no need for a set.
  // Task id to agent URL
  final Map<String, String> _taskToAgent = {};

  final _uuid = Uuid();

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
        content: [TextContent(text: '_registerAgentCallback - args are null')],
        isError: true,
      );
    }
    final url = args['url'];
    A2AAgentCard agentCard;
    try {
      agentCard = await _fetchAgentCard(url);
    } catch (e) {
      return CallToolResult.fromContent(
        content: [
          TextContent(
            text:
                '_registerAgentCallback - exception raised contacting agent at $url, $e',
          ),
        ],
        isError: true,
      );
    }
    if (agentCard.name.isEmpty) {
      print(
        '${Colorize('A2AMcpServer::_registerAgentCallback - cannot ascertain agent name at $url').yellow()}',
      );
      return CallToolResult.fromContent(
        content: [
          TextContent(
            text:
                '_registerAgentCallback - cannot ascertain agent name at $url',
          ),
        ],
        isError: true,
      );
    }
    _registeredAgents[agentCard.name] = agentCard;
    _agentLookup[args['url']] = agentCard.name;
    final content = {"status": "success", "agentName": agentCard.name};
    return CallToolResult.fromStructuredContent(structuredContent: content);
  }

  // List agents callback
  Future<CallToolResult> _listAgentsCallback({
    Map<String, dynamic>? args,
    RequestHandlerExtra? extra,
  }) async {
    final jsonString = json.encode(_registeredAgents.keys.toList());
    final jsonMap = json.decode(jsonString);
    return CallToolResult.fromStructuredContent(
      structuredContent: {"result": jsonMap},
    );
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
        content: [UnknownContent(type: "unknown")],
        isError: true,
      );
    }
    final url = args['url'];
    if (!_agentLookup.containsKey(url)) {
      // Agent not registered
      print(
        '${Colorize('A2AMCPBridge::_registerAgentCallback - agent is not registered').yellow()}',
      );
      return CallToolResult.fromContent(
        content: [TextContent(text: 'Agent is not Registered')],
        isError: true,
      );
    }

    _registeredAgents.remove(_agentLookup[url]);
    _agentLookup.remove(url);

    // Clean up any task mappings related to this agent
    _taskToAgent.removeWhere((_, value) => value == url);

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
        '${Colorize('A2AMCPBridge::_sendMessageCallback - args are null').yellow()}',
      );
      return CallToolResult.fromContent(
        content: [TextContent(text: '_sendMessageCallback - args are null')],
        isError: true,
      );
    }

    final url = args['url'];
    final message = args['message'];
    // Session id if present
    final sessionId = args['session_id'] ?? _uuid.v4();

    // Create a client for the agent and send the message to it
    try {
      final client = A2AClient(url);
      await Future.delayed(Duration(seconds: 2));
      final taskId = _uuid.v4();
      _taskToAgent[taskId] = url;
      final clientMessage = A2AMessage()
        ..contextId =
            sessionId // Use session id
        ..messageId = _uuid.v4()
        ..parts = [A2ATextPart()..text = message]
        ..role = 'user';
      final params = A2AMessageSendParams()
        ..message = clientMessage
        ..metadata = {"task_id": taskId};
      String responseText = 'Response from <${_agentLookup[url]}> agent\n\n';
      // Process the response, only assemble text responses for now.
      final response = await client.sendMessage(params);
      if (response.isError) {
        final errorResponse = response as A2AJSONRPCErrorResponseS;
        print(
          '${Colorize('A2AMCPBridge::_sendMessageCallback - error response ${errorResponse.error?.rpcErrorCode} from agent').yellow()}',
        );
        return CallToolResult.fromContent(
          content: [
            TextContent(
              text:
                  '_sendMessageCallback - Error response returned by the agent at $url, ${errorResponse.error?.rpcErrorCode}',
            ),
          ],
          isError: true,
        );
      } else {
        final successResponse = response as A2ASendMessageSuccessResponse;
        // Check for a message or task
        if (successResponse.result is A2AMessage) {
          final success = successResponse.result as A2AMessage;
          final decodesParts = A2AUtilities.decodeParts(success.parts);
          responseText += decodesParts.allText;
        } else {
          // Task, assume the task has completed Ok.
          final success = successResponse.result as A2ATask;
          if (success.artifacts != null) {
            for (final artifact in success.artifacts!) {
              final decodesParts = A2AUtilities.decodeParts(artifact.parts);
              responseText += decodesParts.allText;
            }
          }
        }
      }

      // Return success
      return CallToolResult.fromStructuredContent(
        structuredContent: {
          "task_id": taskId,
          "response": responseText,
          "status": "success",
        },
      );
    } catch (e) {
      return CallToolResult.fromContent(
        content: [
          TextContent(
            text:
                '_sendMessageCallback - Exception raised interfacing with the agent at $url, $e',
          ),
        ],
        isError: true,
      );
    }
  }

  Future<CallToolResult> _getTaskResultCallback({
    Map<String, dynamic>? args,
    RequestHandlerExtra? extra,
  }) async {
    if (args == null) {
      print(
        '${Colorize('A2AMCPBridge::_getTaskResultCallback - args are null').yellow()}',
      );
      return CallToolResult.fromContent(
        content: [UnknownContent(type: "unknown")],
        isError: true,
      );
    }

    final taskId = args['taskId'];
    final historyLength = args['history_length'];

    if (!_taskToAgent.containsKey(taskId)) {
      print(
        '${Colorize('A2AMCPBridge::_getTaskResultCallback - no registered agent for task Id $taskId').yellow()}',
      );
      return CallToolResult.fromContent(
        content: [TextContent(text: 'No task registered for Task Id $taskId')],
        isError: true,
      );
    }
    final url = _taskToAgent[taskId];
    // Create a client for the agent and send the message to it
    try {
      final client = A2AClient(url!);
      final params = A2ATaskQueryParams()
        ..id = taskId
        ..historyLength = historyLength;
      final response = await client.getTask(params);
      String responseText = '';
      String historyResponseText = '';
      String? taskState = 'unknown';
      if (response.isError) {
        final errorResponse = response as A2AJSONRPCErrorResponseT;
        print(
          '${Colorize('A2AMCPBridge::_sendMessageCallback - error response ${errorResponse.error?.rpcErrorCode} from agent').yellow()}',
        );
        return CallToolResult.fromContent(
          content: [
            TextContent(
              text:
                  'Error response returned the agent at $url, ${errorResponse.error?.rpcErrorCode}',
            ),
          ],
          isError: true,
        );
      } else {
        final successResponse = response as A2AGetTaskSuccessResponse;
        final task = successResponse.result as A2ATask;
        taskState = task.status?.state?.name;
        // Task message
        if (task.status?.message != null) {
          final message = task.status?.message;
          final decodesParts = A2AUtilities.decodeParts(message?.parts);
          responseText = decodesParts.allText;
          // Artifacts
          if (task.artifacts != null) {
            for (final artifact in task.artifacts!) {
              final decodesParts = A2AUtilities.decodeParts(artifact.parts);
              responseText = decodesParts.allText;
            }
          }
          // History
          if (task.history != null) {
            for (final message in task.history!) {
              final decodesParts = A2AUtilities.decodeParts(message.parts);
              historyResponseText = decodesParts.allText;
            }
          }
        }
      }
      // Return success
      return CallToolResult.fromContent(
        content: [
          Content.fromJson({
            "task_id": taskId,
            "message": responseText,
            "status": "success",
            "task_state": taskState,
            "history": historyResponseText,
          }),
        ],
      );
    } catch (e) {
      return CallToolResult.fromContent(
        content: [
          TextContent(
            text:
                '_getTaskResultCallback - Exception raised interfacing with the agent at $url, $e',
          ),
        ],
        isError: true,
      );
    }
  }

  Future<CallToolResult> _cancelTaskCallback({
    Map<String, dynamic>? args,
    RequestHandlerExtra? extra,
  }) async {
    if (args == null) {
      print(
        '${Colorize('A2AMCPBridge::__cancelTaskCallback - args are null').yellow()}',
      );
      return CallToolResult.fromContent(
        content: [UnknownContent(type: "unknown")],
        isError: true,
      );
    }

    final taskId = args['taskId'];

    if (!_taskToAgent.containsKey(taskId)) {
      print(
        '${Colorize('A2AMCPBridge::_cancelTaskCallback - no registered agent for task Id $taskId').yellow()}',
      );
      return CallToolResult.fromContent(
        content: [TextContent(text: 'No task registered for Task Id $taskId')],
        isError: true,
      );
    }
    final url = _taskToAgent[taskId];
    // Create a client for the agent and send the message to it
    try {
      final client = A2AClient(url!);
      final params = A2ATaskIdParams()..id = taskId;
      final response = await client.cancelTask(params);
      if (response.isError) {
        final errorResponse = response as A2AJSONRPCErrorResponse;
        print(
          '${Colorize('A2AMCPBridge::_cancelTaskCallback - error response ${errorResponse.error?.rpcErrorCode} from agent').yellow()}',
        );
        return CallToolResult.fromContent(
          content: [
            TextContent(
              text:
                  'Error response returned the agent at $url, ${errorResponse.error?.rpcErrorCode}',
            ),
          ],
          isError: true,
        );
      } else {
        final successResponse = response as A2ACancelTaskSuccessResponse;
        final task = successResponse.result;
        final taskState = task?.status?.state;
        return taskState == A2ATaskState.canceled ||
                taskState == A2ATaskState.completed ||
                taskState == A2ATaskState.rejected
            ? CallToolResult.fromContent(
                content: [
                  Content.fromJson({"task_id": taskId, "status": "success"}),
                ],
              )
            : CallToolResult.fromContent(
                content: [
                  Content.fromJson({
                    "task_id": taskId,
                    "message":
                        "Task failed to be cancelled, completed or rejected",
                    "status": "error",
                  }),
                ],
              );
      }
    } catch (e) {
      return CallToolResult.fromContent(
        content: [
          TextContent(
            text:
                '_cancelTaskCallback - Exception raised interfacing with the agent at $url, $e',
          ),
        ],
        isError: true,
      );
    }
  }

  void _initialiseTools() {
    // Register agent
    //  Register an A2A agent with the bridge server.
    var inputSchema = ToolInputSchema(
      properties: {
        "url": {"type": "string", "description": "The agent URL"},
      },
      required: ["url"],
    );
    var outputSchema = ToolOutputSchema(
      properties: {
        "status": {"type": "string"},
        "agentName": {"type": "string"},
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
    //  List all registered A2A agents.
    inputSchema = ToolInputSchema(properties: {});
    outputSchema = ToolOutputSchema(
      properties: {
        "type": "array",
        "result": {"type": "string"},
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
    // Unregister an A2A agent from the bridge server.
    inputSchema = ToolInputSchema(
      properties: {
        "url": {"type": "string", "description": "The agent URL"},
      },
      required: ["url"],
    );
    outputSchema = ToolOutputSchema(
      properties: {
        "status": {"type": "string"},
        "message": {"type": "string"},
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
    // Send a message to an A2A agent, non-streaming.
    inputSchema = ToolInputSchema(
      properties: {
        "url": {"type": "string", "description": "The agent URL"},
        "message": {
          "type": "string",
          "description": "Message to send to the agent",
        },
        "session_id": {
          "type": "string",
          "description": "Multi conversation session id",
        },
      },
      required: ["url", "message"],
    );
    outputSchema = ToolOutputSchema(
      properties: {
        "task_id": {"type": "string"},
        "response": {"type": "string"},
        "status": {"type": "string"},
        "message": {"type": "string"},
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

    // Get Task result
    // Retrieve the result of a task from an A2A agent.
    inputSchema = ToolInputSchema(
      properties: {
        "task_id": {"type": "string", "description": "The task id"},
        "history_length ": {
          "type": "number",
          "description":
              " Optional number of history items to include (null for all)",
        },
      },
      required: ["task_id"],
    );
    outputSchema = ToolOutputSchema(
      properties: {
        "task_id": {"type": "string"},
        "message": {"type": "string"},
        "status": {"type": "string"},
        "task_state": {"type": "string"},
        "history": {"type": "string"},
      },
    );
    final getTaskResult = Tool(
      name: 'get_task_result',
      description: 'A2A Bridge retrieves a task result from an Agent',
      inputSchema: inputSchema,
      outputSchema: outputSchema,
    );
    _registeredTools.add(getTaskResult);
    _mcpServer.registerTool(getTaskResult, _getTaskResultCallback);

    // Cancel a task
    // Cancel a running task on an A2A agent.
    inputSchema = ToolInputSchema(
      properties: {
        "task_id": {"type": "string", "description": "The task id"},
      },
      required: ["task_id"],
    );
    outputSchema = ToolOutputSchema(
      properties: {
        "task_id": {"type": "string"},
        "message": {"type": "string"},
        "status": {"type": "string"},
        "result_code": {"type": "string"},
      },
    );
    final cancelTask = Tool(
      name: 'cancel_task',
      description: 'A2A Bridge cancel an active Agent task',
      inputSchema: inputSchema,
      outputSchema: outputSchema,
    );
    _registeredTools.add(cancelTask);
    _mcpServer.registerTool(cancelTask, _cancelTaskCallback);
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
