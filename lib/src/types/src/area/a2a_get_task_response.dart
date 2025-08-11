/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// JSON-RPC response for the 'tasks/get' method.
class A2AGetTaskResponse {
  /// True if the response is an error
  @JsonKey(includeFromJson: false)
  bool isError = false;

  A2AGetTaskResponse();

  factory A2AGetTaskResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error')) {
      final response = A2AJSONRPCErrorResponseT.fromJson(json);
      response.isError = true;
      return response;
    } else {
      return A2AGetTaskSuccessResponse.fromJson((json));
    }
  }

  Map<String, dynamic> toJson() => {};
}

/// Represents a JSON-RPC 2.0 Error Response object.
@JsonSerializable(explicitToJson: true)
final class A2AJSONRPCErrorResponseT extends A2AGetTaskResponse
    with A2AJSONRPCErrorResponseM {
  A2AJSONRPCErrorResponseT();

  factory A2AJSONRPCErrorResponseT.fromJson(Map<String, dynamic> json) =>
      _$A2AJSONRPCErrorResponseTFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AJSONRPCErrorResponseTToJson(this);
}

/// JSON-RPC success response for the 'tasks/get' method.
@JsonSerializable(explicitToJson: true)
final class A2AGetTaskSuccessResponse extends A2AGetTaskResponse {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  String jsonrpc = '2.0';
  A2ATask? result;

  A2AGetTaskSuccessResponse();

  factory A2AGetTaskSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$A2AGetTaskSuccessResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AGetTaskSuccessResponseToJson(this);
}
