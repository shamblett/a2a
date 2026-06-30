/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 30/06/2026
* Copyright :  S.Hamblett
*/

part of '../../../a2a_types.dart';

/// JSON-RPC request model for the 'tasks/get' method.
@JsonSerializable(explicitToJson: true)
final class A2AGetTaskRequest extends A2ARequest {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  @JsonKey(includeToJson: true, includeFromJson: false)
  String jsonrpc = '2.0';

  /// A String containing the name of the method to be invoked.
  @JsonKey(includeToJson: true, includeFromJson: false)
  String method = A2ARequest.tasksGet;

  A2ATaskQueryParams? params;

  A2AGetTaskRequest();

  factory A2AGetTaskRequest.fromJson(Map<String, dynamic> json) =>
      _$A2AGetTaskRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AGetTaskRequestToJson(this);
}

/// A Structured value that holds the parameter values to be used during the invocation of
/// the method.
@JsonSerializable(explicitToJson: true)
class A2ATaskQueryParams extends A2ATaskIdParams{
  /// Number of recent messages to be retrieved.
  int? historyLength;

  A2ATaskQueryParams();

  factory A2ATaskQueryParams.fromJson(Map<String, dynamic> json) =>
      _$A2ATaskQueryParamsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2ATaskQueryParamsToJson(this);
}
