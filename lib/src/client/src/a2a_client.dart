/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

library;

import 'package:oxy/oxy.dart' as http;
import '/src/types/a2a_types.dart';

/// A2AClient is a TypeScript HTTP client for interacting
/// with A2A-compliant agents.
///
class A2AClient {
  String agentBaseUrl = '';

  String serviceEndpointUrl = '';

  late Future<A2AAgentCard> _agentCard;

  int _requestIdCounter = 1;

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

  /// Fetches the Agent Card from the agent's well-known URI and caches its service endpoint URL.
  /// This method is called by the constructor.
  /// @returns A Future that eventually resolves to the AgentCard.
  Future<A2AAgentCard> _fetchAndCacheAgentCard() async {
    final agentCardUrl = '$agentBaseUrl/.well-known/agent.json';
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
      serviceEndpointUrl = agentCard.url;
      return agentCard;
    } catch (e) {
      print('_fetchAndCacheAgentCard:: Error fetching or parsing Agent Card:');
      rethrow;
    }
  }
}
