/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 30/06/2026
* Copyright :  S.Hamblett
*/

part of '../../../a2a_types.dart';

/// JSON-RPC request model for the 'tasks/resubscribe' method.
@JsonSerializable(explicitToJson: true)
final class A2ATaskResubscriptionRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  @JsonKey(includeToJson: true, includeFromJson: false)
  String jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  @JsonKey(includeToJson: true, includeFromJson: false)
  String method = A2ARequest.tasksResubscribe;

  A2ATaskIdParams? params;

  A2ATaskResubscriptionRequest();

  factory A2ATaskResubscriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$A2ATaskResubscriptionRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2ATaskResubscriptionRequestToJson(this);
}
