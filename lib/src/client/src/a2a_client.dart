/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../a2a_client.dart';

/// A2AClient is a HTTP client for interacting
/// with A2A-compliant agents.
///
class A2AClient {
  String agentBaseUrl = '';

  String agentCardPath = A2AConstants.agentCardPath;

  String _serviceEndpointUrl = '';

  A2AAgentCard? _agentCard;

  int _requestIdCounter = 1;

  /// Gets the RPC service endpoint URL. Ensures the agent card has been fetched first.
  /// @returns a [Future] that resolves to the service endpoint URL string.
  /// Defaults to the agent base url [agentBaseUrl].
  Future<String> get serviceEndpoint async {
    if (_serviceEndpointUrl.isNotEmpty) {
      return _serviceEndpointUrl;
    }
    // If serviceEndpointUrl is not set, it means the agent card fetch is pending or failed.
    // Awaiting agentCard will either resolve it or throw if fetching failed.
    if (_agentCard == null) {
      await _fetchAndCacheAgentCard();
    }
    if (_serviceEndpointUrl.isEmpty) {
      // This case should ideally be covered by the error handling in _fetchAndCacheAgentCard
      throw Exception(
        'serviceEndpoint:: Agent Card URL for RPC endpoint is not available. Fetching might have failed.',
      );
    }
    return _serviceEndpointUrl;
  }

  /// Constructs an A2AClient instance.
  ///
  /// The agent card is fetched from the provided agent baseUrl.
  /// The Agent Card is fetched from a path relative to the agentBaseUrl, which defaults to '.well-known/agent-card.json'.
  /// The `url` field from the Agent Card will be used as the RPC service endpoint.
  /// @param agentBaseUrl The base URL of the A2A agent (e.g., https://agent.example.com).
  /// @param optional agentCardPath path to the agent card, defaults to .well-known/agent-card.json
  A2AClient(
    String agentBaseUrl, [
    String agentCardPath = A2AConstants.agentCardPath,
  ]) {
    this.agentBaseUrl = agentBaseUrl.endsWith('/')
        ? agentBaseUrl.substring(0, agentBaseUrl.length - 1)
        : this.agentBaseUrl = agentBaseUrl;

    _serviceEndpointUrl = '$agentBaseUrl/';

    this.agentCardPath = agentCardPath.endsWith('/')
        ? agentCardPath.substring(0, agentCardPath.length - 1)
        : agentCardPath;

    // Fetch the agent card in the background
    Timer(Duration(milliseconds: 10), _getAgentCard);
  }

  /// Retrieves the Agent Card.
  ///
  /// If an `agentBaseUrl` is provided, it fetches the card from that specific URL.
  /// Otherwise, it returns the card fetched and cached during client construction.
  /// @param agentBaseUrl Optional. The base URL of the agent to fetch the card from.
  /// If provided, this will fetch a new card, not use the cached one from the constructor's URL.
  /// @returns A [Future] that resolves to the [A2AAgentCard].
  Future<A2AAgentCard> getAgentCard({
    String? agentBaseUrl,
    String agentCardPath = A2AConstants.agentCardPath,
  }) async {
    if (agentBaseUrl != null) {
      return _fetchAndCacheAgentCard(
        baseUrl: agentBaseUrl,
        agentCardPath: agentCardPath,
      );
    } else {
      if (_agentCard == null) {
        return _fetchAndCacheAgentCard();
      }
    }
    return _agentCard!;
  }

  /// Sends a message to the agent.
  ///
  /// The behavior (blocking/non-blocking) and push notification configuration
  /// are specified within the `params.configuration` object.
  /// Optionally, `params.message.contextId` or `params.message.taskId` can be provided.
  /// @param params The parameters for sending the message, including the message content and configuration.
  /// @returns A [Future? resolving to an [A2ASendMessageResponse], which can be an [A2AMessage], [A2ATask], or an error.
  Future<A2ASendMessageResponse> sendMessage(
    A2AMessageSendParams params,
  ) async {
    final result =
        await _postRpcRequest<A2AMessageSendParams, A2ASendMessageResponse>(
          'message/send',
          params,
        );
    return A2ASendMessageResponse.fromJson(result);
  }

  /// Sends a message to the agent and streams back responses using Server-Sent Events (SSE).
  ///
  /// Push notification configuration can be specified in `params.configuration`.
  /// Optionally, `params.message.contextId` or `params.message.taskId` can be provided.
  /// Requires the agent to support streaming (`capabilities.streaming: true` in AgentCard).
  /// @param params The parameters for sending the message.
  /// @returns yielding [A2ASendStreamMessageResponse] which is one of [A2AMessage], [A2ATask],
  /// [A2ATaskStatusUpdateEvent], or [A2ATaskArtifactUpdateEvent].
  /// Throws an error if streaming is not supported or if an HTTP/SSE error occurs.
  Stream<A2ASendStreamMessageResponse> sendMessageStream(
    A2AMessageSendParams params,
  ) async* {
    // Ensure agent card is fetched
    if (_agentCard != null) {
      if (_agentCard!.capabilities.streaming != null) {
        if (!_agentCard!.capabilities.streaming!) {
          throw Exception(
            'sendMessageStream:: Agent does not support streaming (AgentCard.capabilities.streaming is not true).',
          );
        }
      } else {
        throw Exception(
          'sendMessageStream:: Agent does not support streaming (AgentCard.capabilities.streaming is null).',
        );
      }
    } else {
      throw Exception(
        'sendMessageStream::Agent does not support streaming agent card is null',
      );
    }

    final endpoint = await serviceEndpoint;
    final requestId = _requestIdCounter++;
    final rpcRequest = A2AJsonRpcRequest()
      ..method = 'message/stream'
      ..id = requestId
      ..params = (params as dynamic).toJson();

    final headers = http.Headers()
      ..append('Accept', 'application/json')
      ..append('Content-Type', 'text/event-stream');
    if (params.extensions.isNotEmpty) {
      headers.append('X-A2A-Extensions', params.extensions.join(','));
    }

    final response = await http.fetch(
      endpoint,
      method: 'POST',
      headers: headers,
      body: http.Body.json(rpcRequest.toJson()),
    );

    if (!response.ok) {
      var errorBody = '';
      try {
        errorBody = await response.text();
        final errorJson = json.decode(errorBody) as Map<String, dynamic>;
        if (errorJson.containsKey('error')) {
          throw Exception(
            'sendMessageStream:: HTTP error establishing stream for message/stream: '
            ' ${response.status} ${response.statusText}. RPC Error: ${(errorJson as dynamic).error.message} '
            ' (Code: ${(errorJson as dynamic).error.code})',
          );
        }
      } catch (e, s) {
        Error.throwWithStackTrace(
          'sendMessageStream:: HTTP error establishing stream, Status: ${response.status}'
          'Status text: ${response.statusText} Response: $errorBody',
          s,
        );
      }
      throw Exception(
        'sendMessageStream::  HTTP error establishing stream, Status: ${response.status}'
        'Status text: ${response.statusText}',
      );
    }
    if (!response.headers
        .get('Content-Type')!
        .startsWith('text/event-stream')) {
      // Server should explicitly set this content type for SSE.
      throw Exception(
        "sendMessageStream::  Invalid response Content-Type for SSE stream. Expected 'text/event-stream'.",
      );
    }
    // Yield events from the parsed SSE stream.
    // Each event's 'data' field is a JSON-RPC response.
    yield* _parseA2ASseStream(response, requestId);
  }

  /// Sets or updates the push notification configuration for a given task.
  ///
  /// Requires the agent to support push notifications (`capabilities.pushNotifications: true` in AgentCard).
  /// @param params Parameters containing the taskId and the [A2ATaskPushNotificationConfig].
  /// @returns A [Future] resolving to [A2ASetTaskPushNotificationConfigResponse].
  Future<A2ASetTaskPushNotificationConfigResponse>
  setTaskPushNotificationConfig(A2ATaskPushNotificationConfig params) async {
    // Ensure agent card is fetched
    if (_agentCard != null) {
      if (_agentCard!.capabilities.pushNotifications != null) {
        if (!_agentCard!.capabilities.pushNotifications!) {
          throw Exception(
            'setTaskPushNotificationConfig:: Agent does not support push notification (AgentCard.capabilities.pushnotifications is not true).',
          );
        }
      } else {
        throw Exception(
          'setTaskPushNotificationConfig:: Agent does not support push notifications(AgentCard.capabilities.pushnotifications is null).',
        );
      }
    } else {
      throw Exception(
        'setTaskPushNotificationConfig:: Agent does not support push notifications agent card is null',
      );
    }

    // The 'params' directly matches the structure expected by the RPC method.
    final result =
        await _postRpcRequest<
          A2ATaskPushNotificationConfig,
          A2ASetTaskPushNotificationConfigResponse
        >('tasks/pushNotificationConfig/set', params);

    return A2ASetTaskPushNotificationConfigResponse.fromJson(result);
  }

  /// Gets the push notification configuration for a given task.
  ///
  /// @param params Parameters containing the taskId and the id of the
  /// push notification to get.
  /// @returns A [Future] resolving to [A2AGetTaskPushNotificationConfigResponse].
  Future<A2AGetTaskPushNotificationConfigResponse>
  getTaskPushNotificationConfig(
    A2AGetTaskPushNotificationConfigParams params,
  ) async {
    // Ensure agent card is fetched
    if (_agentCard != null) {
      if (_agentCard!.capabilities.pushNotifications != null) {
        if (!_agentCard!.capabilities.pushNotifications!) {
          throw Exception(
            'getTaskPushNotificationConfig:: Agent does not support push notification (AgentCard.capabilities.pushnotifications is not true).',
          );
        }
      } else {
        throw Exception(
          'getTaskPushNotificationConfig:: Agent does not support push notifications(AgentCard.capabilities.pushnotifications is null).',
        );
      }
    } else {
      throw Exception(
        'getTaskPushNotificationConfig:: Agent does not support push notifications agent card is null',
      );
    }

    // The 'params' directly matches the structure expected by the RPC method.
    final result =
        await _postRpcRequest<
          A2AGetTaskPushNotificationConfigParams,
          A2AGetTaskPushNotificationConfigResponse
        >('tasks/pushNotificationConfig/get', params);

    return A2AGetTaskPushNotificationConfigResponse.fromJson(result);
  }

  /// Lists the push notification configuration for a given task.
  ///
  /// @param params Parameters containing the taskId.
  /// @returns A [Future] resolving to [A2ListTaskPushNotificationConfigResponse].
  Future<A2AListTaskPushNotificationConfigResponse>
  listTaskPushNotificationConfig(
    A2AListTaskPushNotificationConfigParams params,
  ) async {
    // Ensure agent card is fetched
    if (_agentCard != null) {
      if (_agentCard!.capabilities.pushNotifications != null) {
        if (!_agentCard!.capabilities.pushNotifications!) {
          throw Exception(
            'listTaskPushNotificationConfig:: Agent does not support push notification (AgentCard.capabilities.pushnotifications is not true).',
          );
        }
      } else {
        throw Exception(
          'listTaskPushNotificationConfig:: Agent does not support push notifications(AgentCard.capabilities.pushnotifications is null).',
        );
      }
    } else {
      throw Exception(
        'listTaskPushNotificationConfig:: Agent does not support push notifications agent card is null',
      );
    }

    // The 'params' directly matches the structure expected by the RPC method.
    final result =
        await _postRpcRequest<
          A2AListTaskPushNotificationConfigParams,
          A2AListTaskPushNotificationConfigResponse
        >('tasks/pushNotificationConfig/get', params);

    return A2AListTaskPushNotificationConfigResponse.fromJson(result);
  }

  /// Deletes a push notification configuration for a given task.
  ///
  /// @param params Parameters containing the taskId and the id of the push notification
  /// to delete.
  /// @returns A [Future] resolving to [A2ListTaskPushNotificationConfigResponse].
  Future<A2ADeleteTaskPushNotificationConfigResponse>
  deleteTaskPushNotificationConfig(
    A2ADeleteTaskPushNotificationConfigParams params,
  ) async {
    // Ensure agent card is fetched
    if (_agentCard != null) {
      if (_agentCard!.capabilities.pushNotifications != null) {
        if (!_agentCard!.capabilities.pushNotifications!) {
          throw Exception(
            'deleteTaskPushNotificationConfig:: Agent does not support push notification (AgentCard.capabilities.pushnotifications is not true).',
          );
        }
      } else {
        throw Exception(
          'deleteTaskPushNotificationConfig:: Agent does not support push notifications(AgentCard.capabilities.pushnotifications is null).',
        );
      }
    } else {
      throw Exception(
        'deleteTaskPushNotificationConfig:: Agent does not support push notifications agent card is null',
      );
    }

    // The 'params' directly matches the structure expected by the RPC method.
    final result =
        await _postRpcRequest<
          A2ADeleteTaskPushNotificationConfigParams,
          A2ADeleteTaskPushNotificationConfigResponse
        >('tasks/pushNotificationConfig/get', params);

    return A2ADeleteTaskPushNotificationConfigResponse.fromJson(result);
  }

  /// Retrieves a task by its ID.
  ///
  /// @param params Parameters containing the taskId and optional historyLength.
  /// @returns A [Future] resolving to [A2AGetTaskResponse], which contains the Task object or an error.
  Future<A2AGetTaskResponse> getTask(A2ATaskQueryParams params) async {
    final result =
        await _postRpcRequest<A2ATaskQueryParams, A2AGetTaskResponse>(
          'tasks/get',
          params,
        );
    return A2AGetTaskResponse.fromJson(result);
  }

  /// Cancels a task by its ID.
  ///
  /// @param params Parameters containing the taskId.
  /// @returns A [Future] resolving to [A2ACancelTaskResponse], which contains the updated Task object or an error.
  Future<A2ACancelTaskResponse> cancelTask(A2ATaskIdParams params) async {
    final result =
        await _postRpcRequest<A2ATaskIdParams, A2ACancelTaskResponse>(
          'tasks/cancel',
          params,
        );
    return A2ACancelTaskResponse.fromJson(result);
  }

  /// Resubscribes to a task's event stream using Server-Sent Events (SSE).
  ///
  /// This is used if a previous SSE connection for an active task was broken.
  /// Requires the agent to support streaming (`capabilities.streaming: true` in AgentCard).
  /// @param params Parameters containing the taskId.
  /// @returns Yields [A2ASendStreamingMessageResponse], one of [A2AMessage], [A2ATask],
  /// [A2ATaskStatusUpdateEvent] or [A2ATaskArtifactUpdateEvent]).
  Stream<A2ASendStreamMessageResponse> resubscribeTask(
    A2ATaskIdParams params,
  ) async* {
    // Ensure agent card is fetched
    if (_agentCard != null) {
      if (_agentCard!.capabilities.streaming != null) {
        if (!_agentCard!.capabilities.streaming!) {
          throw Exception(
            'resubscribeTask:: Agent does not support streaming (AgentCard.capabilities.streaming is not true).',
          );
        }
      } else {
        throw Exception(
          'resubscribeTask:: Agent does not support streaming (AgentCard.capabilities.streaming is null).',
        );
      }
    } else {
      throw Exception(
        'resubscribeTask::Agent does not support streaming agent card is null',
      );
    }

    final endpoint = await serviceEndpoint;
    final requestId = _requestIdCounter++;
    final rpcRequest = A2AJsonRpcRequest()
      ..method = 'tasks/resubscribe'
      ..id = requestId
      ..params = (params as dynamic).toJson();

    final headers = http.Headers()
      ..append('Accept', 'application/json')
      ..append('Content-Type', 'text/event-stream');
    final response = await http.fetch(
      endpoint,
      method: 'POST',
      headers: headers,
      body: http.Body.json(rpcRequest.toJson()),
    );

    if (!response.ok) {
      var errorBody = '';
      errorBody = await response.text();
      final errorJson = json.decode(errorBody) as Map<String, dynamic>;
      if (errorJson.containsKey('error')) {
        yield (A2AJSONRPCErrorResponseSSM.fromJson(errorJson))..isError = true;
      }
      if (!response.headers
          .get('Content-Type')!
          .startsWith('text/event-stream')) {
        // Server should explicitly set this content type for SSE.
        throw Exception(
          "sendMessageStream::  Invalid response Content-Type for SSE stream. Expected 'text/event-stream'.",
        );
      }
    }
    // Yield events from the parsed SSE stream.
    // Each event's 'data' field is a JSON-RPC response.
    yield* _parseA2ASseStream(response, requestId);
  }

  // Fetches the Agent Card from the agent's well-known URI and caches its service endpoint URL.
  //
  // If a [baseUrl] parameter is supplied this will be used instead of the agent base url and
  // the card details will not be cached, just returned.
  // This method is called by the constructor via a timer callback
  // @returns A Future that resolves to the AgentCard.
  Future<A2AAgentCard> _fetchAndCacheAgentCard({
    String baseUrl = '',
    String agentCardPath = A2AConstants.agentCardPath,
  }) async {
    var fetchUrl = agentBaseUrl;
    bool cache = true;
    if (baseUrl.isNotEmpty) {
      if (baseUrl.endsWith('/')) {
        baseUrl = baseUrl.substring(0, baseUrl.length - 1);
      }
      fetchUrl = baseUrl;
      cache = false;
    }
    final agentCardUrl = '$fetchUrl/$agentCardPath';
    try {
      final response = await http.fetch(
        agentCardUrl,
        headers: http.Headers()..append('Accept', 'application/json'),
      );
      if (!response.ok) {
        throw Exception(
          'fetchAndCacheAgentCard:: Failed to fetch Agent Card from $agentCardUrl: ${response.status} :  '
          '${response.statusText}',
        );
      }
      final agentCardJson = await response.json();
      final agentCard = A2AAgentCard.fromJson(agentCardJson);
      if (agentCard.url.isEmpty) {
        throw Exception(
          'fetchAndCacheAgentCard:: Fetched Agent Card does not contain a valid "url" for the service endpoint.',
        );
      }
      if (cache) {
        _serviceEndpointUrl = agentCard.url;
        _agentCard = agentCard;
      }
      return agentCard;
    } catch (e) {
      print('_fetchAndCacheAgentCard:: Error fetching or parsing Agent Card:');
      rethrow;
    }
  }

  // Helper method to make a generic JSON-RPC POST request.
  //
  // @param method The RPC method name.
  // @param params The parameters for the RPC method.
  // @returns A Future that resolves to the RPC response.
  Future<Map<String, dynamic>> _postRpcRequest<TParams, TResponse>(
    String method,
    TParams params,
  ) async {
    final endpoint = await serviceEndpoint;
    final requestId = _requestIdCounter++;
    final rpcRequest = A2AJsonRpcRequest()
      ..method = method
      ..id = requestId
      ..params = (params as dynamic).toJson();

    final headers = http.Headers()
      ..append('Accept', 'application/json')
      ..append('Content-Type', 'application/json');
    if (params is A2AMessageSendParams && params.extensions.isNotEmpty) {
      headers.append('X-A2A-Extensions', params.extensions.join(','));
    }
    final httpResponse = await http.fetch(
      endpoint,
      method: 'POST',
      headers: headers,
      body: http.Body.json(rpcRequest.toJson()),
    );

    if (!httpResponse.ok) {
      var errorBodyText = '(empty or non-JSON response)';
      try {
        errorBodyText = await httpResponse.clone().text();
        final errorJson = (json.decode(errorBodyText) as Map<String, dynamic>);
        // If the body is a valid JSON-RPC error response, let it be handled by the standard parsing below.
        // However, if it's not even a JSON-RPC structure but still an error, throw based on HTTP status.
        if (!errorJson.containsKey('jsonrpc') &&
            errorJson.containsKey('error')) {
          final error = json.encode(errorJson['error']['data']);
          throw Exception(
            '_postRpcRequest:: RPC error for $method: ${errorJson["error"]["message"]} '
            '(Code: ${errorJson["error"]["code"]}, HTTP Status: ${httpResponse.status}), Data: $error',
          );
        } else if (!errorJson.containsKey('jsonrpc')) {
          throw Exception(
            '_postRpcRequest:: HTTP error for $method Status: ${httpResponse.status} ${httpResponse.statusText}. '
            'Response: $errorBodyText',
          );
        }
      } on FormatException catch (e, s) {
        // Empty body maybe
        Error.throwWithStackTrace(
          '_postRpcRequest:: Format exception : ${e.message}',
          s,
        );
      } catch (e) {
        // If parsing the error body fails or it's not a JSON-RPC error, throw a generic HTTP error.
        // If it was already an error thrown from within the try block, rethrow it.
        if (e.toString().contains('RPC error for') ||
            e.toString().contains('HTTP error for')) {
          rethrow;
        }
      }
    }

    final rpcResponse = (await httpResponse.json() as Map<String, dynamic>);
    if (rpcResponse.containsKey('id')) {
      if (rpcResponse['id'] != null && rpcResponse['id'] != requestId) {
        // This is a significant issue for request-response matching.
        throw Exception(
          '_postRpcRequest:: RPC response ID mismatch for method $method. Expected $requestId, got ${rpcResponse["id"]}',
        );
      }
    }

    // Return the response
    return rpcResponse;
  }

  // Parses an HTTP response body as an A2A Server-Sent Event stream.
  //
  // Each 'data' field of an SSE event is expected to be a JSON-RPC 2.0 Response object,
  // specifically a SendStreamingMessageResponse.
  // @param response The HTTP Response object whose body is the SSE stream.
  // @param originalRequestId The ID of the client's JSON-RPC request that initiated this stream.
  // Used to validate the `id` in the streamed JSON-RPC responses.
  // @returns Yields the `result` field of each valid JSON-RPC success response from the stream
  // or an RPC Error response if an error is returned as a A2ASendStreamMessageResponse.
  Stream<A2ASendStreamMessageResponse> _parseA2ASseStream(
    http.Response response,
    A2AId originalRequestId,
  ) async* {
    try {
      final body = http.Body(response.body);
      final text = await body.text();
      if (text.isEmpty) {
        throw Exception(
          '_parseA2ASseStream:: SSE response body is undefined. Cannot read stream.',
        );
      }
      LineSplitter ls = LineSplitter();
      final lines = ls.convert(text);
      for (final line in lines) {
        if (line.isEmpty) {
          continue;
        }
        final j = json.decode(line.substring(6));
        final item = A2ASendStreamMessageResponse.fromJson(j);
        if (item.isError) {
          yield item;
        }
        final typedItem = item as A2ASendStreamMessageSuccessResponse;
        if (typedItem.id != null && typedItem.id != originalRequestId) {
          throw Exception(
            '_parseA2ASseStream:: Request/Response id mismatch. Rx : ${item.id}, Tx : $originalRequestId',
          );
        }
        yield item;
      }
    } catch (e, s) {
      Error.throwWithStackTrace(e, s);
    }
  }

  // Construction timer callback to get the agent card
  Future<void> _getAgentCard() async => await _fetchAndCacheAgentCard();
}
