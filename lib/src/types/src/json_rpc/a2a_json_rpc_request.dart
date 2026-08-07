/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 30/06/2026
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// Represents a JSON-RPC 2.0 Request object.
@JsonSerializable(explicitToJson: true)
class A2AJsonRpcRequest {
  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  @JsonKey(includeToJson: true, includeFromJson: false)
  String jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  String method = '';

  /// A Structured value that holds the parameter values to be used during the invocation of the method.
  A2ASV? params;

  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  A2AJsonRpcRequest();

  factory A2AJsonRpcRequest.fromJson(Map<String, dynamic> json) =>
      _$A2AJsonRpcRequestFromJson(json);

  Map<String, dynamic> toJson() => _$A2AJsonRpcRequestToJson(this);
}
