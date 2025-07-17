/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// JSON-RPC response for the 'tasks/cancel' method.
class A2ACancelTaskResponse {
  A2ACancelTaskResponse();

  factory A2ACancelTaskResponse.fromJson(Map<String, dynamic> json) {
    return !json.containsKey('error')
        ? A2AJSONRPCErrorResponse.fromJson(json)
        : A2ACancelTaskSuccessResponse.fromJson((json));
  }

  Map<String, dynamic> toJson() {
    if (this is A2AJSONRPCErrorResponse) {
      return (this as A2AJSONRPCErrorResponse).toJson();
    }
    if (this is A2ACancelTaskSuccessResponse) {
      return (this as A2ACancelTaskSuccessResponse).toJson();
    }

    return {};
  }
}

/// JSON-RPC response for the 'tasks/cancel' method.
@JsonSerializable(explicitToJson: true)
final class A2AJSONRPCErrorResponse extends A2ACancelTaskResponse
    with A2AJSONRPCErrorResponseM {
  A2AJSONRPCErrorResponse();

  factory A2AJSONRPCErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$A2AJSONRPCErrorResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AJSONRPCErrorResponseToJson(this);
}

/// JSON-RPC success response model for the 'tasks/cancel' method.
@JsonSerializable(explicitToJson: true)
final class A2ACancelTaskSuccessResponse extends A2ACancelTaskResponse {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  final jsonrpc = '2.0';
  A2ATask? result;

  A2ACancelTaskSuccessResponse();

  factory A2ACancelTaskSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$A2ACancelTaskSuccessResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2ACancelTaskSuccessResponseToJson(this);
}
