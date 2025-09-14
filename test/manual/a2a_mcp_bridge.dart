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

const agentUrl = 'http://localhost:9999';

Future<void> main() async {
  // Start the client
  await client.connect(clientTransport);

  test('Server Version', () async {
    final serverVersion = client.getServerVersion();
    expect(serverVersion, isNotNull);
    expect(serverVersion?.name, 'A2A MCP Bridge Server');
    expect(serverVersion?.version, '1.0.0');
  });
  test('List Tools', () async {
    final tools = await client.listTools();
    expect(tools.tools.length, 6);
    expect(tools.tools.first.name, 'register_agent');
    expect(tools.tools[1].name, 'list_agents');
    expect(tools.tools[2].name, 'unregister_agent');
    expect(tools.tools[3].name, 'send_message');
    expect(tools.tools[4].name, 'get_task_result');
    expect(tools.tools.last.name, 'cancel_task');
  });
  test('List Agents', () async {
    final params = CallToolRequestParams(name: 'list_agents');
    final result = await client.callTool(params);
    expect(result.isError, isNull);
    final content = result.structuredContent;
    expect(content['result'] is List, isTrue);
  });
  test('Register Agent - null arguments', () async {
    final params = CallToolRequestParams(name: 'register_agent');
    final result = await client.callTool(params);
    expect(result.isError, isTrue);
    final content = result.content;
    expect(content.first.type, 'text');
    expect(
      (content.first as TextContent).text,
      '_registerAgentCallback - args are null',
    );
  });
  test('Register Agent Agent contacted', () async {
    final params = CallToolRequestParams(
      name: 'register_agent',
      arguments: {'url': agentUrl},
    );
    final result = await client.callTool(params);
    expect(result.isError, isNull);
    final content = result.structuredContent;
    expect(content['status'], 'success');
    expect(content['agentName'], 'Hello World Agent');
    final params1 = CallToolRequestParams(name: 'list_agents');
    final result1 = await client.callTool(params1);
    expect(result1.isError, isNull);
    final content1 = result1.structuredContent;
    expect(content1.length, 1);
    expect(content1['result'], ['Hello World Agent']);
  });
  test('Send Message - null arguments', () async {
    final params = CallToolRequestParams(name: 'send_message');
    final result = await client.callTool(params);
    expect(result.isError, isTrue);
    final content = result.content;
    expect(content.first.type, 'text');
    expect(
      (content.first as TextContent).text,
      '_sendMessageCallback - args are null',
    );
  });
  test('Send Message - valid arguments', () async {
    final paramsReg = CallToolRequestParams(
      name: 'register_agent',
      arguments: {'url': agentUrl},
    );
    await client.callTool(paramsReg);
    final params = CallToolRequestParams(
      name: 'send_message',
      arguments: {'url': agentUrl, 'message': 'Hello agent'},
    );
    final result = await client.callTool(params);
    expect(result.isError, isNull);
    final content = result.structuredContent;
    expect(content['task_id'] is String, isTrue);
    expect(content['status'], 'success');
    expect(
      content['response'],
      'Response from <Hello World Agent> agent\n\nHello World',
    );
  });
  test('Unregister Agent - null arguments', () async {
    final params = CallToolRequestParams(name: 'unregister_agent');
    final result = await client.callTool(params);
    expect(result.isError, isTrue);
    final content = result.content;
    expect(content.first.type, 'text');
    expect(
      (content.first as TextContent).text,
      '_unregisterAgentCallback - args are null',
    );
  });
  test('Unregister Agent - valid arguments', () async {
    final params = CallToolRequestParams(
      name: 'unregister_agent',
      arguments: {'url': 'http://localhost:9999'},
    );
    final result = await client.callTool(params);
    expect(result.isError, isNull);
    final content = result.structuredContent;
    expect(content['status'], 'success');
  });
  test('Get Task Result - null arguments', () async {
    final params = CallToolRequestParams(name: 'get_task_result');
    final result = await client.callTool(params);
    expect(result.isError, isTrue);
    final content = result.content;
    expect(content.first.type, 'text');
    expect(
      (content.first as TextContent).text,
      '_getTaskResultCallback - args are null',
    );
  });
  test('Get Task Result - valid arguments', () async {
    final paramsReg = CallToolRequestParams(
      name: 'register_agent',
      arguments: {'url': agentUrl},
    );
    await client.callTool(paramsReg);
    var params = CallToolRequestParams(
      name: 'send_message',
      arguments: {'url': agentUrl, 'message': 'Hello agent'},
    );
    var result = await client.callTool(params);
    expect(result.isError, isNull);
    var content = result.structuredContent;
    final taskId = content['task_id'];
    params = CallToolRequestParams(
      name: 'get_task_result',
      arguments: {'task_id': taskId},
    );
    result = await client.callTool(params);
    expect(result.isError, isTrue);
    final content1 = result.content.first;
    expect((content1 as TextContent).text.contains('32001'), isTrue);
  });
  test('Cancel Task - null arguments', () async {
    final params = CallToolRequestParams(name: 'cancel_task');
    final result = await client.callTool(params);
    expect(result.isError, isTrue);
    final content = result.content;
    expect(content.first.type, 'text');
    expect(
      (content.first as TextContent).text,
      '_cancelTaskCallback - args are null',
    );
  });
  test('Cancel Task - valid arguments', () async {
    final paramsReg = CallToolRequestParams(
      name: 'register_agent',
      arguments: {'url': agentUrl},
    );
    await client.callTool(paramsReg);
    var params = CallToolRequestParams(
      name: 'send_message',
      arguments: {'url': agentUrl, 'message': 'Hello agent'},
    );
    var result = await client.callTool(params);
    expect(result.isError, isNull);
    var content = result.structuredContent;
    final taskId = content['task_id'];
    params = CallToolRequestParams(
      name: 'cancel_task',
      arguments: {'task_id': taskId},
    );
    result = await client.callTool(params);
    expect(result.isError, isTrue);
    final content1 = result.content.first;
    expect((content1 as TextContent).text.contains('32001'), isTrue);
  });
}
