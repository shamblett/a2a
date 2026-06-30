/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 30/06/2026
* Copyright :  S.Hamblett
*/

part of '../../../a2a_types.dart';

/// JSON-RPC request model for the 'tasks/cancel' method.
@JsonSerializable(explicitToJson: true)
final class A2ACancelTaskRequest extends A2ARequest {
  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  @JsonKey(includeToJson: true, includeFromJson: false)
  String jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  @JsonKey(includeToJson: true, includeFromJson: false)
  String method = A2ARequest.tasksCancel;

  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  A2ATaskIdParams? params;

  A2ACancelTaskRequest();

  factory A2ACancelTaskRequest.fromJson(Map<String, dynamic> json) =>
      _$A2ACancelTaskRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2ACancelTaskRequestToJson(this);
}

/// A Structured value that holds the parameter values to be used during the invocation of
/// the method.
@JsonSerializable(explicitToJson: true)
class A2ATaskIdParams {
  /// The unique identifier (e.g. UUID) of the task.
  String id = '';

  /// Metadata
  A2ASV? metadata;

  A2ATaskIdParams();

  factory A2ATaskIdParams.fromJson(Map<String, dynamic> json) =>
      _$A2ATaskIdParamsFromJson(json);

  Map<String, dynamic> toJson() => _$A2ATaskIdParamsToJson(this);
}
