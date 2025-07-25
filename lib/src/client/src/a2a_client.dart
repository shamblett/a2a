/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

library;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:oxy/oxy.dart' as http;
import '/src/types/a2a_types.dart';

/// A2AClient is a TypeScript HTTP client for interacting
/// with A2A-compliant agents.
///
class A2AClient {
  String agentBaseUrl = '';

  late String _serviceEndpointUrl;

  A2AAgentCard? _agentCard;

  int _requestIdCounter = 1;

  /// Gets the RPC service endpoint URL. Ensures the agent card has been fetched first.
  /// @returns a future that resolves to the service endpoint URL string.
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
  /// It initiates fetching the agent card from the provided agent baseUrl.
  /// The Agent Card is expected at `${agentBaseUrl}/.well-known/agent.json`.
  /// The `url` field from the Agent Card will be used as the RPC service endpoint.
  /// @param agentBaseUrl The base URL of the A2A agent (e.g., https://agent.example.com).
  A2AClient(String agentBaseUrl) {
    if (agentBaseUrl.endsWith('/')) {
      this.agentBaseUrl = agentBaseUrl.substring(0, agentBaseUrl.length - 1);
    } else {
      this.agentBaseUrl = agentBaseUrl;
    }
    _fetchAndCacheAgentCard();
  }

  /// Retrieves the Agent Card.
  /// If an `agentBaseUrl` is provided, it fetches the card from that specific URL.
  /// Otherwise, it returns the card fetched and cached during client construction.
  /// @param agentBaseUrl Optional. The base URL of the agent to fetch the card from.
  /// If provided, this will fetch a new card, not use the cached one from the constructor's URL.
  /// @returns A Promise that resolves to the AgentCard.
  Future<A2AAgentCard> getAgentCard({String? agentBaseUrl}) async {
    final completer = Completer<A2AAgentCard>();
    if (agentBaseUrl != null) {
      final agentCard = await _fetchAndCacheAgentCard(baseUrl: agentBaseUrl);
      completer.complete(agentCard);
    } else {
      // If no specific URL is given, return the initially configured agent's card.
      completer.complete(_agentCard);
    }
    return completer.future;
  }

  /// Sends a message to the agent.
  /// The behavior (blocking/non-blocking) and push notification configuration
  /// are specified within the `params.configuration` object.
  /// Optionally, `params.message.contextId` or `params.message.taskId` can be provided.
  /// @param params The parameters for sending the message, including the message content and configuration.
  /// @returns A Promise resolving to SendMessageResponse, which can be a Message, Task, or an error.
  Future<A2ASendMessageResponse> sendMessage(
    A2AMessageSendParams params,
  ) async =>
      await _postRpcRequest<A2AMessageSendParams, A2ASendMessageResponse>(
        'message/send',
        params,
      );

  /// Sends a message to the agent and streams back responses using Server-Sent Events (SSE).
  /// Push notification configuration can be specified in `params.configuration`.
  /// Optionally, `params.message.contextId` or `params.message.taskId` can be provided.
  /// Requires the agent to support streaming (`capabilities.streaming: true` in AgentCard).
  /// @param params The parameters for sending the message.
  /// @returns yielding [A2AStreamEventData] (Message, Task, TaskStatusUpdateEvent, or TaskArtifactUpdateEvent).
  /// The generator throws an error if streaming is not supported or if an HTTP/SSE error occurs.
  Stream<A2AStreamEventData> sendMessageStream(
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
      ..params = params as A2ASV;

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
    yield* _parseA2ASseStream<A2AStreamEventData>(response, requestId);
  }

  /// Sets or updates the push notification configuration for a given task.
  /// Requires the agent to support push notifications (`capabilities.pushNotifications: true` in AgentCard).
  /// @param params Parameters containing the taskId and the TaskPushNotificationConfig.
  /// @returns A Promise resolving to SetTaskPushNotificationConfigResponse.
  Future<A2ASetTaskPushNotificationConfigResponse>
  setTaskPushNotificationConfig(A2ATaskPushNotificationConfig params) async {
    // Ensure agent card is fetched
    if (_agentCard != null) {
      if (_agentCard!.capabilities.pushNotifications != null) {
        if (!_agentCard!.capabilities.streaming!) {
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
    return _postRpcRequest<
      A2ATaskPushNotificationConfig,
      A2ASetTaskPushNotificationConfigResponse
    >('tasks/pushNotificationConfig/set', params);
  }

  /// Gets the push notification configuration for a given task.
  /// @param params Parameters containing the taskId.
  /// @returns A Promise resolving to GetTaskPushNotificationConfigResponse.
  Future<A2AGetTaskPushNotificationConfigResponse>
  getTaskPushNotificationConfig(A2ATaskIdParams params) async {
    // The 'params' (TaskIdParams) directly matches the structure expected by the RPC method.
    return _postRpcRequest<
      A2ATaskIdParams,
      A2AGetTaskPushNotificationConfigResponse
    >('tasks/pushNotificationConfig/get', params);
  }

  /// Retrieves a task by its ID.
  /// @param params Parameters containing the taskId and optional historyLength.
  /// @returns A Promise resolving to GetTaskResponse, which contains the Task object or an error.
  Future<A2AGetTaskResponse> getTask(A2ATaskQueryParams params) async =>
      _postRpcRequest<A2ATaskQueryParams, A2AGetTaskResponse>(
        'tasks/get',
        params,
      );

  /// Cancels a task by its ID.
  /// @param params Parameters containing the taskId.
  /// @returns A Promise resolving to CancelTaskResponse, which contains the updated Task object or an error.
  Future<A2ACancelTaskResponse> cancelTask(A2ATaskIdParams params) async =>
      _postRpcRequest<A2ATaskIdParams, A2ACancelTaskResponse>(
        'tasks/cancel',
        params,
      );

  /// Resubscribes to a task's event stream using Server-Sent Events (SSE).
  /// This is used if a previous SSE connection for an active task was broken.
  /// Requires the agent to support streaming (`capabilities.streaming: true` in AgentCard).
  /// @param params Parameters containing the taskId.
  /// @returns An AsyncGenerator yielding A2AStreamEventData ([A2AMessage], [A2ATask],
  /// [A2ATaskStatusUpdateEvent], or [A2ATaskArtifactUpdateEvent]).
  Stream<A2AStreamEventData> resubscribeTask(A2ATaskIdParams params) async* {
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
      ..params = params as A2ASV;

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
      try {
        errorBody = await response.text();
        final errorJson = json.decode(errorBody) as Map<String, dynamic>;
        if (errorJson.containsKey('error')) {
          throw Exception(
            'resubscribeTask:: HTTP error establishing stream for tasks/resubscribe: '
            ' ${response.status} ${response.statusText}. RPC Error: ${(errorJson as dynamic).error.message} '
            ' (Code: ${(errorJson as dynamic).error.code})',
          );
        }
      } catch (e, s) {
        Error.throwWithStackTrace(
          'resubscribeTask:: HTTP error establishing stream, Status: ${response.status}'
          'Status text: ${response.statusText} Response: $errorBody',
          s,
        );
      }
      throw Exception(
        'resubscribeTask::  HTTP error establishing stream, Status: ${response.status}'
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
    yield* _parseA2ASseStream<A2AStreamEventData>(response, requestId);
  }

  /// Fetches the Agent Card from the agent's well-known URI and caches its service endpoint URL.
  /// If a [baseUrl] parameter is supplied this will be used instead of the agent base url and
  /// the card details will not be cached, just returned.
  /// This method is called by the constructor.
  /// @returns A Future that eventually resolves to the AgentCard.
  Future<A2AAgentCard> _fetchAndCacheAgentCard({String baseUrl = ''}) async {
    var fetchUrl = agentBaseUrl;
    bool cache = true;
    if (baseUrl.isNotEmpty) {
      if (baseUrl.endsWith('/')) {
        baseUrl = baseUrl.substring(0, baseUrl.length - 1);
      }
      fetchUrl = baseUrl;
      cache = false;
    }
    final agentCardUrl = '$fetchUrl/.well-known/agent.json';
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

  /// Helper method to make a generic JSON-RPC POST request.
  /// @param method The RPC method name.
  /// @param params The parameters for the RPC method.
  /// @returns A Promise that resolves to the RPC response.
  Future<TResponse> _postRpcRequest<TParams, TResponse>(
    String method,
    TParams params,
  ) async {
    final endpoint = await serviceEndpoint;
    final requestId = _requestIdCounter++;
    final rpcRequest = A2AJsonRpcRequest()
      ..method = method
      ..id = requestId
      ..params = params as A2ASV;

    final headers = http.Headers()
      ..append('Accept', 'application/json')
      ..append('Content-Type', 'application/json');
    final httpResponse = await http.fetch(
      endpoint,
      method: 'POST',
      headers: headers,
      body: http.Body.json(rpcRequest.toJson()),
    );

    if (!httpResponse.ok) {
      var errorBodyText = '(empty or non-JSON response)';
      try {
        errorBodyText = await httpResponse.text();
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
            '_postRpcRequest:: HTTP error for $method Status: ${httpResponse.status} ${httpResponse.statusText}. Response: $errorBodyText',
          );
        }
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
    if (rpcResponse.containsKey('id') && rpcResponse['id']! == requestId) {
      // This is a significant issue for request-response matching.
      throw Exception(
        '_postRpcRequest:: RPC response ID mismatch for method $method. Expected $requestId, got ${rpcResponse["id"]}',
      );
    }

    // Return the response
    dynamic response;
    return (response.fromJson(rpcResponse) as TResponse);
  }

  /// Parses an HTTP response body as an A2A Server-Sent Event stream.
  /// Each 'data' field of an SSE event is expected to be a JSON-RPC 2.0 Response object,
  /// specifically a SendStreamingMessageResponse (or similar structure for resubscribe).
  /// @param response The HTTP Response object whose body is the SSE stream.
  /// @param originalRequestId The ID of the client's JSON-RPC request that initiated this stream.
  /// Used to validate the `id` in the streamed JSON-RPC responses.
  /// @returns An AsyncGenerator yielding the `result` field of each valid JSON-RPC success response from the stream.
  Stream<TStreamItem> _parseA2ASseStream<TStreamItem>(
    http.Response response,
    A2AId originalRequestId,
  ) async* {
    if (await response.body.isEmpty) {
      throw Exception(
        '_parseA2ASseStream:: SSE response body is undefined. Cannot read stream.',
      );
    }

    final transformer = StreamTransformer<Uint8List, String>.fromHandlers(
      handleData: (data, sink) {
        sink.add(Utf8Decoder().convert(data));
      },
    );
    final reader = response.body.transform(transformer);
    List<String> buffer = []; // Holds incomplete lines from the stream
    String eventDataBuffer =
        ''; // Holds accumulated 'data:' lines for the current event

    try {
      while (true) {
        final value = await reader.first;
        if (await reader.isEmpty) {
          if (eventDataBuffer.isNotEmpty) {
            final result = _processSseEventData<TStreamItem>(
              eventDataBuffer,
              originalRequestId,
            );
            yield result;
          }
          break;
        }
        buffer.add(value);
        for (String line in buffer) {
          if (line.contains('\n')) {
            line = line.trim();
            if (line.isEmpty) {
              // Empty line: signifies the end of an event
              if (eventDataBuffer.isNotEmpty) {
                // If we have accumulated data for an event
                //const result = this._processSseEventData<TStreamItem>(eventDataBuffer, originalRequestId);
                //yield result;
                eventDataBuffer = ''; // Reset buffer for the next event
              }
            } else if (line.startsWith('data:')) {
              // Append data (multi-line data is possible)
              eventDataBuffer += line.substring(5);
              // Comment lines starting with : in SSE are ignored
              // Other SSE fields like 'event:', 'id:', 'retry:'.
              // The A2A spec primarily focuses on the 'data' field for JSON-RPC payloads.
              // For now, we don't specifically handle these other SSE fields unless required by spec.
            }
          }
        }
        buffer.clear();
      }
    } catch (e, s) {
      Error.throwWithStackTrace(e, s);
    }
  }

  /// Processes a single SSE event's data string, expecting it to be a JSON-RPC response.
  /// @param jsonData The string content from one or more 'data:' lines of an SSE event.
  /// @param originalRequestId The ID of the client's request that initiated the stream.
  /// @returns The `result` field of the parsed JSON-RPC success response.
  /// @throws Error if data is not valid JSON, not a valid JSON-RPC response, an error response,
  /// or ID mismatch.
  TStreamItem _processSseEventData<TStreamItem>(
    String jsonData,
    A2AId? originalRequestId,
  ) {
    if (jsonData.isEmpty) {
      throw Exception(
        '_processSseEventData:: Attempted to process empty SSE event data.',
      );
    }

    try {
      final sseJsonResponse = json.decode(jsonData);
      final a2aStreamResponse =
          (A2ASendStreamingMessageResponse.fromJson(sseJsonResponse)
              as A2ASendStreamingMessageSuccessResponse);

      // According to JSON-RPC spec, notifications (which SSE events can be seen as) might not have an ID,
      // or if they do, it should match. A2A spec implies streamed events are tied to the initial request.
      if (a2aStreamResponse.id != originalRequestId) {
        throw Exception(
          '_processSseEventData:: SSE Event'
          's JSON-RPC response ID mismatch. '
          'Client request ID: $originalRequestId, event response ID: ${a2aStreamResponse.id}',
        );
      }

      if (a2aStreamResponse.isError) {
        final err = a2aStreamResponse as A2AJSONRPCErrorResponseSSM;
        throw Exception(
          '_processSseEventData:: SSE event contained an error: ${err.error}',
        );
      }

      // Check if 'result' exists, as it's mandatory for successful JSON-RPC responses
      if (a2aStreamResponse.result == null) {
        throw Exception(
          '_processSseEventData:: SSE event JSON-RPC response is missing "result" field. Data: $jsonData',
        );
      }

      return a2aStreamResponse.result as TStreamItem;
    } catch (e, s) {
      // Catch errors from JSON.parse or if it's an error response that was thrown by this function
      if (e.toString().contains('SSE event contained an error') ||
          e.toString().contains(
            'SSE event JSON-RPC response is missing "result" field',
          )) {
        Error.throwWithStackTrace(e, s);
      }
      // For other parsing errors or unexpected structures:
      Error.throwWithStackTrace(
        '_processSseEventData:: Failed to parse SSE event data: "${jsonData.substring(0, 100)}',
        s,
      );
    }
  }
}
