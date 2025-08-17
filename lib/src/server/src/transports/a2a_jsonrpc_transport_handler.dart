/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_server.dart';

/// Handles JSON-RPC transport layer, routing requests to an [A2ARequestHandler].
class A2AJsonRpcTransportHandler {
  final A2ARequestHandler _requestHandler;

  A2AJsonRpcTransportHandler(this._requestHandler);

  /// Handles an incoming JSON-RPC request.
  ///
  /// For streaming methods, it returns an AsyncGenerator of JSONRPCResult.
  /// For non-streaming methods, it returns a Future of a single JSONRPCMessage
  /// (Result or ErrorResponse).
  A2AResponseOrGenerator handle(Object requestBody) async {
    var rpcRequest = A2ARequest();

    try {
      if (requestBody is String) {
        rpcRequest = A2ARequest.fromJson(json.decode(requestBody));
        if (rpcRequest.unknownRequest) {
          throw A2AServerError.invalidRequest(
            'A2AJsonRpcTransportHandler::handle '
            'Invalid JSON-RPC request structure.',
            null,
          );
        }
      } else if (requestBody is A2ARequest) {
        rpcRequest = requestBody;
      } else {
        throw A2AServerError.parseError(
          'A2AJsonRpcTransportHandler::handle '
          'Invalid request body type.',
          null,
        );
      }
    } catch (e, s) {
      Error.throwWithStackTrace(
        A2AServerError.unsupportedOperation(
          'A2AJsonRpcTransportHandler::handle '
          ' Supplied request body cannot be parsed - { $requestBody }',
        ),
        s,
      );
    }
  }
}
