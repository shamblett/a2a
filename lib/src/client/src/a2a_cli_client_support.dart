/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../a2a_client.dart';

///
/// Support class for the A2A CLI Client
///
class A2ACLIClientSupport {
  /// The client and its base URL
  static A2AClient? client;
  static String baseUrl = '';

  /// Agent name
  static String agentName =
      'Agent'; // Default, try to get from agent card later

  /// Streaming support
  static bool agentSupportsStreaming = false;

  /// State
  static String currentTaskId = '';
  static String currentContextId = '';

  /// Uuid
  static final uuid = Uuid();

  /// No streaming
  static bool noStreaming = false;
}
