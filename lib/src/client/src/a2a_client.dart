/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

library;

import 'dart:convert';

import 'package:oxy/oxy.dart' as http;
import '/src/types/a2a_types.dart';

/// A2AClient is a TypeScript HTTP client for interacting
/// with A2A-compliant agents.
///
class A2AClient {
  String agentBaseUrl = '';

  late String _serviceEndpointUrl;

  late Future<A2AAgentCard> _agentCard;

  int _requestIdCounter = 1;

  /// Gets the RPC service endpoint URL. Ensures the agent card has been fetched first.
  /// @returns a future that resolves to the service endpoint URL string.
  Future<String> get serviceEndpoint async {
    if (_serviceEndpointUrl.isNotEmpty) {
      return _serviceEndpointUrl;
    }
    // If serviceEndpointUrl is not set, it means the agent card fetch is pending or failed.
    // Awaiting agentCard will either resolve it or throw if fetching failed.
    await _agentCard;
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
    _agentCard = _fetchAndCacheAgentCard();
  }

  /// Retrieves the Agent Card.
  /// If an `agentBaseUrl` is provided, it fetches the card from that specific URL.
  /// Otherwise, it returns the card fetched and cached during client construction.
  /// @param agentBaseUrl Optional. The base URL of the agent to fetch the card from.
  /// If provided, this will fetch a new card, not use the cached one from the constructor's URL.
  /// @returns A Promise that resolves to the AgentCard.
  Future<A2AAgentCard> getAgentCard({String? agentBaseUrl}) async {
    if (agentBaseUrl != null) {
      return _fetchAndCacheAgentCard(baseUrl: agentBaseUrl);
    }
    // If no specific URL is given, return the initially configured agent's card.
    return _agentCard;
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
            'RPC error for $method: ${errorJson["error"]["message"]} '
            '(Code: ${errorJson["error"]["code"]}, HTTP Status: ${httpResponse.status}), Data: $error',
          );
        } else if (!errorJson.containsKey('jsonrpc')) {
          throw Exception(
            'HTTP error for $method Status: ${httpResponse.status} ${httpResponse.statusText}. Response: $errorBodyText',
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
        'RPC response ID mismatch for method $method. Expected $requestId, got ${rpcResponse["id"]}',
      );
    }

    // Return the response
    dynamic response;
    return (response.fromJson(rpcResponse) as TResponse);
  }
}
