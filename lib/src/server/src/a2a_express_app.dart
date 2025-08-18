/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../a2a_server.dart';

class A2AExpressApp {
  final A2ARequestHandler _requestHandler; // Kept for getAgentCard
  final A2AJsonRpcTransportHandler _jsonRpcTransportHandler;

  A2AExpressApp(this._requestHandler, this._jsonRpcTransportHandler);
}
