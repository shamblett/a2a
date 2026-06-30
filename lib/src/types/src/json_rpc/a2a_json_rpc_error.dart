/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 30/06/2026
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// Represents a JSON-RPC 2.0 Error object.
@JsonSerializable(explicitToJson: true)
final class A2AJSONRPCError extends A2AError {
  /// A Number that indicates the error type that occurred.
  @JsonKey(includeToJson: true, includeFromJson: false)
  int code = A2AError.jsonRpc;

  /// A String providing a short description of the error.
  String message = '';

  /// A Primitive or Structured value that contains additional information about the error.
  /// This may be omitted.
  A2ASV? data;

  A2AJSONRPCError();

  factory A2AJSONRPCError.fromJson(Map<String, dynamic> json) =>
      _$A2AJSONRPCErrorFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AJSONRPCErrorToJson(this);
}
