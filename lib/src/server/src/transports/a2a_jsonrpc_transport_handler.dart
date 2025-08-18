/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_server.dart';

/// Supported request types
const supportedTypes = <Type>[
  A2ASendMessageRequest,
  A2ASendStreamingMessageRequest,
  A2ATaskResubscriptionRequest,
  A2ASendMessageRequest,
  A2AGetTaskRequest,
  A2ACancelTaskRequest,
  A2ASetTaskPushNotificationConfigRequest,
  A2ASetTaskPushNotificationConfigRequest,
];

/// Handles JSON-RPC transport layer, routing requests to an [A2ARequestHandler].
class A2AJsonRpcTransportHandler {
  final A2ARequestHandler _requestHandler;

  A2AJsonRpcTransportHandler(this._requestHandler);

  /// Handles an incoming JSON-RPC request.
  ///
  /// For streaming methods, it returns an AsyncGenerator of JSONRPCResult.
  /// For non-streaming methods, it returns a Future of a single JSONRPCMessage
  /// (Result or ErrorResponse).
  Future<A2AResponseOrGenerator>? handle(Object requestBody) async {
    dynamic rpcRequest;

    try {
      rpcRequest = requestBody is String
          ? A2ARequest.fromJson(json.decode(requestBody))
          : requestBody;
      if (!supportedTypes.contains(rpcRequest.runtimeType)) {
        throw A2AServerError.invalidRequest(
          'A2AJsonRpcTransportHandler::handle '
          'Invalid JSON-RPC request structure.',
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
    // rpcRequest is a valid request now
    try {
      if (rpcRequest is A2ASendStreamingMessageRequest ||
          rpcRequest is A2ATaskResubscriptionRequest) {
        final agentCard = await _requestHandler.agentCard;
        if (agentCard.capabilities.streaming == null ||
            (agentCard.capabilities.streaming == false)) {
          throw A2AServerError.unsupportedOperation(
            'A2AJsonRpcTransportHandler::handle '
            ' Request requires streaming capability',
          );
        }

        final requestId = rpcRequest.id;
        final agentEventStream = rpcRequest is A2ASendStreamingMessageRequest
            ? _requestHandler.sendMessageStream(rpcRequest.params!)
            : _requestHandler.resubscribe(rpcRequest.params);

        return (() async* {
          try {
            await for (final event in agentEventStream) {
              final ret = A2ASendStreamingMessageSuccessResponse();
              ret.id = requestId;
              ret.result = event;
              yield ret;
            }
          } catch (e, s) {
            // If the underlying agent stream throws an error, we need to yield a JSONRPCErrorResponse.
            // However, an AsyncGenerator is expected to yield JSONRPCResult.
            // This indicates an issue with how errors from the agent's stream are propagated.
            // For now, log it. The Express layer will handle the generator ending.
            print(
              '${Colorize('A2AJsonRpcTransportHandler::handle  Error in agent event stream for (request $requestId}): $e').yellow()}',
            );
            // Ideally, the Express layer should catch this and send a final error to the client if the stream breaks.
            // Or, the agentEventStream itself should yield a final error event that gets wrapped.
            // For now, we re-throw so it can be caught by A2AExpressApp's stream handling.
            Error.throwWithStackTrace(e, s);
          }
        });
      } else {
        // Handle non-streaming methods
        switch (rpcRequest) {
          case A2ASendMessageRequest _:
            final result = await _requestHandler.sendMessage(
              rpcRequest.params!,
            );
            final ret = result as A2AResultResolver;
            if (ret.result != null) {
              return A2ASendMessageSuccessResponse()
                ..id = rpcRequest.id
                ..result = result;
            } else {
              // Error
              if (ret.error != null) {
                final jrpc = (ret.error as A2AServerError).toJSONRPCError();
                return jrpc as A2AJSONRPCErrorResponseS;
              } else {
                return A2AJSONRPCErrorResponseS();
              }
            }
          case A2AGetTaskRequest _:
            final result = await _requestHandler.getTask(rpcRequest.params!);
            return A2AGetTaskSuccessResponse()
              ..id = rpcRequest.id
              ..result = result;
          case A2ACancelTaskRequest _:
            final result = await _requestHandler.cancelTask(rpcRequest.params!);
            return A2ACancelTaskSuccessResponse()
              ..id = rpcRequest.id
              ..result = result;
          case A2ASetTaskPushNotificationConfigRequest _:
            final result = await _requestHandler.setTaskPushNotificationConfig(
              rpcRequest.params!,
            );
            return A2ASetTaskPushNotificationConfigSuccessResponse()
              ..id = rpcRequest.id
              ..result = result?.pushNotificationConfig;
          case A2AGetTaskPushNotificationConfigRequest _:
            final result = await _requestHandler.getTaskPushNotificationConfig(
              rpcRequest.params!,
            );
            return A2AGetTaskPushNotificationConfigSuccessResponse()
              ..id = rpcRequest.id
              ..result = result?.pushNotificationConfig;
          default:
            throw A2AServerError.methodNotFound(
              'A2AJsonRpcTransportHandler::handle',
            );
        }
      }
    } catch (e, s) {
      Error.throwWithStackTrace(
        A2AServerError.internalError(
          'A2AJsonRpcTransportHandler::handle '
          ' An unexpected error occurred',
          null,
        ),
        s,
      );
    }
  }
}
