/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 30/06/2026
* Copyright :  S.Hamblett
*/

part of '../../../a2a_types.dart';

/// JSON-RPC request model for the 'message/stream' method.
@JsonSerializable(explicitToJson: true)
final class A2ASendStreamingMessageRequest extends A2ARequest {
  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  @JsonKey(includeToJson: true, includeFromJson: false)
  String jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  @JsonKey(includeToJson: true, includeFromJson: false)
  String method = A2ARequest.messageStream;

  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  A2AMessageSendParams? params;

  A2ASendStreamingMessageRequest();

  factory A2ASendStreamingMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$A2ASendStreamingMessageRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2ASendStreamingMessageRequestToJson(this);
}
