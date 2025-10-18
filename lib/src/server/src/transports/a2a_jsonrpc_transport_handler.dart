// ignore_for_file: prefer-static-class

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
  A2AGetTaskPushNotificationConfigRequest,
  A2ADeleteTaskPushNotificationConfigRequest,
  A2AListTaskPushNotificationConfigRequest,
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
          : A2ARequest.fromJson(requestBody as Map<String, dynamic>);
      if (rpcRequest.unknownRequest) {
        throw A2AServerError.invalidRequest(
          'A2AJsonRpcTransportHandler::handle '
          'Invalid JSON-RPC request structure.',
          null,
        );
      }
    } catch (e) {
      // Fallback for parsing error, likely from A2A Inspector
      final requestMap = requestBody as Map<String, dynamic>;
      if (requestMap.containsKey('method') &&
          requestMap['method'] == A2ARequest.messageStream) {
        print(
          Colorize(
            'Caught parsing error, manually constructing streaming request.',
          )..yellow(),
        );
        rpcRequest = A2ASendStreamingMessageRequest()
          ..id = requestMap['id']
          ..params = A2AMessageSendParams.fromJson(
            requestMap['params'] as Map<String, dynamic>,
          );
      } else {
        rethrow;
      }
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
        final agentEventStream = <A2AResult>[];
        if (rpcRequest is A2ASendStreamingMessageRequest) {
          await for (final event in _requestHandler.sendMessageStream(
            rpcRequest.params!,
          )) {
            agentEventStream.add(event);
          }
        } else {
          // Must be resubscribe
          await for (final event in _requestHandler.resubscribe(
            rpcRequest.params,
          )) {
            agentEventStream.add(event);
          }
        }
        // Return an async generator for the events stream
        return (() async* {
          try {
            for (final event in agentEventStream) {
              final responseMap = {
                'jsonrpc': '2.0',
                'id': requestId,
                'result': (event as dynamic).toJson(),
              };
              yield A2ASendStreamMessageResponse.fromJson(responseMap);
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
              final responseMap = {
                'jsonrpc': '2.0',
                'id': rpcRequest.id,
                'result': (ret.result as dynamic).toJson(),
              };
              return A2ASendMessageSuccessResponse().fromJson(responseMap);
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
              ..result = result;
          case A2AListTaskPushNotificationConfigRequest _:
            final result = await _requestHandler
                .listTaskPushNotificationConfigs(rpcRequest.params!);
            return A2AListTaskPushNotificationConfigSuccessResponse()
              ..id = rpcRequest.id
              ..result = result;
          case A2ADeleteTaskPushNotificationConfigRequest _:
            await _requestHandler.deleteTaskPushNotificationConfig(
              rpcRequest.params!,
            );
            return A2ADeleteTaskPushNotificationConfigSuccessResponse()
              ..id = rpcRequest.id
              ..result = null;
          default:
            throw A2AServerError.methodNotFound(
              'A2AJsonRpcTransportHandler::handle',
            );
        }
      }
    } catch (e, s) {
      // Check for unsupported operations or operations which can fail
      if (e is A2APushNotificationNotSupportedError) {
        rethrow;
      }
      if (e is A2ATaskNotFoundError) {
        rethrow;
      }

      // General failure
      print(
        '${Colorize('Exception raised in A2A Transport handler, message is ${(e as dynamic).message}').yellow()}',
      );
      Error.throwWithStackTrace(
        A2AServerError.internalError(
          'A2AJsonRpcTransportHandler::handle '
          ' An unexpected error occurred - ${(e as dynamic).message}',
          null,
        ),
        s,
      );
    }
  }
}
