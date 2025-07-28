/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// JSON-RPC response model for the 'message/send' method.
class A2ASendStreamMessageResponse {
  /// True if the response is an error
  @JsonKey(includeFromJson: false)
  bool isError = false;

  A2ASendStreamMessageResponse();

  factory A2ASendStreamMessageResponse.fromJson(Map<String, dynamic> json) {
    return json.containsKey('result')
          ? A2ASendStreamMessageSuccessResponseR.fromJson(json)
          : A2AJSONRPCErrorResponseSSM.fromJson(json)
      ..isError = true;
  }

  Map<String, dynamic> toJson() {
    if (this is A2ASendStreamMessageSuccessResponseR) {
      return (this as A2ASendStreamMessageSuccessResponseR).toJson();
    }

    return {};
  }
}

/// JSON RPC error response object
@JsonSerializable(explicitToJson: true)
final class A2AJSONRPCErrorResponseSSM extends A2ASendStreamMessageResponse
    with A2AJSONRPCErrorResponseM {
  A2AJSONRPCErrorResponseSSM();

  factory A2AJSONRPCErrorResponseSSM.fromJson(Map<String, dynamic> json) =>
      _$A2AJSONRPCErrorResponseSSMFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$A2AJSONRPCErrorResponseSSMToJson(this);
}

/// JSON-RPC success response model for the 'message/stream' method.
/// This response is also used to carry streaming responses from the server(SSE)
/// in its [result] parameter.
@JsonSerializable(explicitToJson: true)
final class A2ASendStreamMessageSuccessResponseR
    extends A2ASendStreamMessageResponse {
  /// An identifier established by the Client that MUST contain a String, Number.
  /// Numbers SHOULD NOT contain fractional parts.
  A2AId? id;

  /// Specifies the version of the JSON-RPC protocol. MUST be exactly "2.0".
  String jsonrpc = '2.0';

  /// The result object on success, [A2ATask], [A2AMessage], [A2ATaskStatusUpdateEvent]
  /// [A2ATaskArtifactUpdateEvent]
  Object? result;

  A2ASendStreamMessageSuccessResponseR();

  factory A2ASendStreamMessageSuccessResponseR.fromJson(
    Map<String, dynamic> json,
  ) {
    final response = _$A2ASendStreamMessageSuccessResponseRFromJson(json);

    if (json.containsKey('result')) {
      if (json['result']['kind'] == 'task') {
        response.result = _$A2ATaskFromJson(json['result']);
        return response;
      }
      if (json['result']['kind'] == 'message') {
        response.result = _$A2AMessageFromJson(json['result']);
        return response;
      }
      if (json['result']['kind'] == 'status-update') {
        response.result = _$A2ATaskStatusUpdateEventFromJson(json['result']);
        return response;
      }
      if (json['result']['kind'] == 'artifact-update') {
        response.result = _$A2ATaskArtifactUpdateEventFromJson(json['result']);
        return response;
      }
    }

    return A2ASendStreamMessageSuccessResponseR();
  }

  @override
  Map<String, dynamic> toJson() {
    final json = _$A2ASendStreamMessageSuccessResponseRToJson(this);
    if (result != null) {
      if (result is A2ATask) {
        json['result'] = _$A2ATaskToJson(result as A2ATask);
        return json;
      }
      if (result is A2AMessage) {
        json['result'] = _$A2AMessageToJson(result as A2AMessage);
        return json;
      }
      if (result is A2ATask) {
        json['result'] = _$A2ATaskToJson(result as A2ATask);
        return json;
      }
      if (result is A2ATaskStatusUpdateEvent) {
        json['result'] = _$A2ATaskStatusUpdateEventToJson(
          result as A2ATaskStatusUpdateEvent,
        );
        return json;
      }
      if (result is A2ATaskArtifactUpdateEvent) {
        json['result'] = _$A2ATaskArtifactUpdateEventToJson(
          result as A2ATaskArtifactUpdateEvent,
        );
        return json;
      }
    }
    return json;
  }
}

/// Sent by server during sendStream or subscribe requests
@JsonSerializable(explicitToJson: true)
final class A2ATaskStatusUpdateEvent {
  /// The context the task is associated with
  String contextId = '';

  /// Indicates the end of the event stream.
  /// Note, this is called 'final' in the TS code.
  bool end = false;

  /// Event type
  String kind = 'status-update';

  /// Extension metadata.
  A2ASV? metadata;
  A2ATaskStatus? status;

  /// Task Id
  String taskId = '';

  A2ATaskStatusUpdateEvent();

  factory A2ATaskStatusUpdateEvent.fromJson(Map<String, dynamic> json) =>
      _$A2ATaskStatusUpdateEventFromJson(json);

  Map<String, dynamic> toJson() => _$A2ATaskStatusUpdateEventToJson(this);
}

/// Sent by server during sendStream or subscribe requests
@JsonSerializable(explicitToJson: true)
final class A2ATaskArtifactUpdateEvent {
  /// Indicates if this artifact appends to a previous one
  bool? append;
  A2AArtifact? artifact;

  /// The context the task is associated with
  String contextId = '';

  /// Event type
  String kind = 'artifact-update';

  /// Indicates if this is the last chunk of the artifact
  bool? lastChunk;

  /// Extension metadata.
  A2ASV? metadata;

  /// Task Id
  String taskId = '';

  A2ATaskArtifactUpdateEvent();

  factory A2ATaskArtifactUpdateEvent.fromJson(Map<String, dynamic> json) =>
      _$A2ATaskArtifactUpdateEventFromJson(json);

  Map<String, dynamic> toJson() => _$A2ATaskArtifactUpdateEventToJson(this);
}
