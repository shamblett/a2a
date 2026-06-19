/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 19/06/2026
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// JSON-RPC response for the 'ListTasks' method.
class A2AListTasksResponse {
  /// True if the response is an error
  @JsonKey(includeFromJson: false)
  bool isError = false;

  A2AListTasksResponse();

  factory A2AListTasksResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error')) {
      final response = A2AJSONRPCErrorResponseTL.fromJson(json);
      response.isError = true;
      return response;
    } else {
      return A2AListTasksSuccessResponse.fromJson((json));
    }
  }

  Map<String, dynamic> toJson() => {};
}

/// Represents a JSON-RPC 2.0 Error Response object.
@JsonSerializable(explicitToJson: true)
final class A2AJSONRPCErrorResponseTL extends A2AListTasksResponse
    with A2AJSONRPCErrorResponseM {
  A2AJSONRPCErrorResponseTL();

  factory A2AJSONRPCErrorResponseTL.fromJson(Map<String, dynamic> json) =>
      _$A2AJSONRPCErrorResponseTLFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AJSONRPCErrorResponseTLToJson(this);
}

/// JSON-RPC success response for the 'ListTasks' method containing an array of tasks and
/// pagination information.
@JsonSerializable(explicitToJson: true)
final class A2AListTasksSuccessResponse extends A2AListTasksResponse {
  /// Array of tasks matching the specified criteria.
  List<A2ATask> tasks = [];

  /// A token to retrieve the next page of results, or empty if there
  /// are no more results in the list.
  String nextPageToken = '';

  /// The page size used for this response.
  int pageSize = 0;

  /// Total number of tasks available (before pagination).
  int totalSize = 0;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  @JsonKey(includeToJson: true, includeFromJson: false)
  String jsonrpc = '2.0';

  A2AListTasksSuccessResponse();

  factory A2AListTasksSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$A2AListTasksSuccessResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AListTasksSuccessResponseToJson(this);
}
