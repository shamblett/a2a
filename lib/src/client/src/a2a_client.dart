/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

library;

import 'package:oxy/oxy.dart' as http;
import '/src/types/types.dart';

/// A2AClient is a TypeScript HTTP client for interacting
/// with A2A-compliant agents.
///
class A2AClient {
  String _agentBaseUrl = '';

  late Future<A2AAgentCard> _agentCardPromise;

  int _requestIdCounter = 1;

  late String _serviceEndpointUrl;

  /// Constructs an A2AClient instance.
  ///
  /// It initiates fetching the agent card from the provided agent baseUrl.
  /// The Agent Card is expected at `${agentBaseUrl}/.well-known/agent.json`.
  /// The `url` field from the Agent Card will be used as the RPC service endpoint.
  /// @param agentBaseUrl The base URL of the A2A agent (e.g., https://agent.example.com).
  A2AClient(String agentBaseUrl) {
    _agentBaseUrl = agentBaseUrl.replaceAll(
      '//\$/',
      '',
    ); // Remove trailing slash if any
    _agentCardPromise = _fetchAndCacheAgentCard();
  }

  /// Fetches the Agent Card from the agent's well-known URI and caches its service endpoint URL.
  /// This method is called by the constructor.
  /// @returns A Promise that resolves to the AgentCard.
  Future<A2AAgentCard> _fetchAndCacheAgentCard() async {
    final agentCardUrl = '$_agentBaseUrl/.well-known/agent.json';
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
      final agentCard = await response.json() as A2AAgentCard;
      if (agentCard.url.isEmpty) {
        throw Exception(
          'fetchAndCacheAgentCard:: Fetched Agent Card does not contain a valid "url" for the service endpoint.',
        );
      }
      _serviceEndpointUrl = agentCard.url;
      return agentCard;
    } catch (e) {
      print('_fetchAndCacheAgentCard:: Error fetching or parsing Agent Card:');
      rethrow;
    }
  }
}
