// ignore_for_file: prefer-match-file-name

/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../a2a_types.dart';

class A2AType {}

/// The ID type, String or num.
typedef A2AId = Object;

/// Structured value type
typedef A2ASV = Map<String, dynamic>;

/// Result type
typedef A2AResult = Object;

typedef A2ATaskOrMessage = Object;

/// Agent Execution Event
typedef A2AAgentExecutionEvent = Object;

/// Transport handler response or async* function.
typedef A2AResponseOrGenerator = Object;

/// Agent class
class A2AAgent {}

/// Common JSON error response mixin
mixin A2AJSONRPCErrorResponseM {
  A2AError? error;

  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  @JsonKey(includeToJson: true, includeFromJson: false)
  String jsonrpc = '2.0';
}

/// Represents a JSON-RPC 2.0 Request object.
@JsonSerializable(explicitToJson: true)
class A2AJsonRpcRequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  @JsonKey(includeToJson: true, includeFromJson: false)
  String jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  String method = 'get';

  /// A Structured value that holds the parameter values to be used during the invocation of the method.
  A2ASV? params;

  A2AJsonRpcRequest();

  factory A2AJsonRpcRequest.fromJson(Map<String, dynamic> json) =>
      _$A2AJsonRpcRequestFromJson(json);

  Map<String, dynamic> toJson() => _$A2AJsonRpcRequestToJson(this);
}
