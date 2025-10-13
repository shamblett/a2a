// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'a2a_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

A2AMessage _$A2AMessageFromJson(Map<String, dynamic> json) => A2AMessage()
  ..contextId = json['contextId'] as String?
  ..extensions = (json['extensions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList()
  ..messageId = json['messageId'] as String
  ..metadata = json['metadata'] as Map<String, dynamic>?
  ..parts = (json['parts'] as List<dynamic>?)
      ?.map((e) => A2APart.fromJson(e as Map<String, dynamic>))
      .toList()
  ..referenceTaskIds = (json['referenceTaskIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList()
  ..role = json['role'] as String
  ..taskId = json['taskId'] as String?;

Map<String, dynamic> _$A2AMessageToJson(A2AMessage instance) =>
    <String, dynamic>{
      'contextId': instance.contextId,
      'extensions': instance.extensions,
      'kind': instance.kind,
      'messageId': instance.messageId,
      'metadata': instance.metadata,
      'parts': instance.parts?.map((e) => e.toJson()).toList(),
      'referenceTaskIds': instance.referenceTaskIds,
      'role': instance.role,
      'taskId': instance.taskId,
    };

A2AArtifact _$A2AArtifactFromJson(Map<String, dynamic> json) => A2AArtifact()
  ..artifactId = json['artifactId'] as String
  ..description = json['description'] as String?
  ..extensions = (json['extensions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList()
  ..metadata = json['metadata'] as Map<String, dynamic>?
  ..name = json['name'] as String?
  ..parts = (json['parts'] as List<dynamic>)
      .map((e) => A2APart.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$A2AArtifactToJson(A2AArtifact instance) =>
    <String, dynamic>{
      'artifactId': instance.artifactId,
      'description': instance.description,
      'extensions': instance.extensions,
      'metadata': instance.metadata,
      'name': instance.name,
      'parts': instance.parts.map((e) => e.toJson()).toList(),
    };

A2ATask _$A2ATaskFromJson(Map<String, dynamic> json) => A2ATask()
  ..artifacts = (json['artifacts'] as List<dynamic>?)
      ?.map((e) => A2AArtifact.fromJson(e as Map<String, dynamic>))
      .toList()
  ..contextId = json['contextId'] as String
  ..history = (json['history'] as List<dynamic>?)
      ?.map((e) => A2AMessage.fromJson(e as Map<String, dynamic>))
      .toList()
  ..id = json['id'] as String
  ..metadata = json['metadata'] as Map<String, dynamic>?
  ..status = json['status'] == null
      ? null
      : A2ATaskStatus.fromJson(json['status'] as Map<String, dynamic>);

Map<String, dynamic> _$A2ATaskToJson(A2ATask instance) => <String, dynamic>{
  'artifacts': instance.artifacts?.map((e) => e.toJson()).toList(),
  'contextId': instance.contextId,
  'history': instance.history?.map((e) => e.toJson()).toList(),
  'id': instance.id,
  'kind': instance.kind,
  'metadata': instance.metadata,
  'status': instance.status?.toJson(),
};

A2ATaskStatus _$A2ATaskStatusFromJson(Map<String, dynamic> json) =>
    A2ATaskStatus()
      ..message = json['message'] == null
          ? null
          : A2AMessage.fromJson(json['message'] as Map<String, dynamic>)
      ..state = $enumDecodeNullable(_$A2ATaskStateEnumMap, json['state'])
      ..timestamp = json['timestamp'] as String?;

Map<String, dynamic> _$A2ATaskStatusToJson(A2ATaskStatus instance) =>
    <String, dynamic>{
      'message': instance.message?.toJson(),
      'state': _$A2ATaskStateEnumMap[instance.state],
      'timestamp': instance.timestamp,
    };

const _$A2ATaskStateEnumMap = {
  A2ATaskState.submitted: 'submitted',
  A2ATaskState.working: 'working',
  A2ATaskState.inputRequired: 'input-required',
  A2ATaskState.completed: 'completed',
  A2ATaskState.canceled: 'canceled',
  A2ATaskState.failed: 'failed',
  A2ATaskState.rejected: 'rejected',
  A2ATaskState.authRequired: 'auth-required',
  A2ATaskState.unknown: 'unknown',
};

A2AJsonRpcRequest _$A2AJsonRpcRequestFromJson(Map<String, dynamic> json) =>
    A2AJsonRpcRequest()
      ..id = json['id']
      ..method = json['method'] as String
      ..params = json['params'] as Map<String, dynamic>?;

Map<String, dynamic> _$A2AJsonRpcRequestToJson(A2AJsonRpcRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jsonrpc': instance.jsonrpc,
      'method': instance.method,
      'params': instance.params,
    };

A2AJSONRPCError _$A2AJSONRPCErrorFromJson(Map<String, dynamic> json) =>
    A2AJSONRPCError()
      ..data = json['data'] as Map<String, dynamic>?
      ..message = json['message'] as String;

Map<String, dynamic> _$A2AJSONRPCErrorToJson(A2AJSONRPCError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'message': instance.message,
    };

A2AJSONParseError _$A2AJSONParseErrorFromJson(Map<String, dynamic> json) =>
    A2AJSONParseError()
      ..data = json['data'] as Map<String, dynamic>?
      ..message = json['message'] as String;

Map<String, dynamic> _$A2AJSONParseErrorToJson(A2AJSONParseError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'message': instance.message,
    };

A2AInvalidRequestError _$A2AInvalidRequestErrorFromJson(
  Map<String, dynamic> json,
) => A2AInvalidRequestError()
  ..data = json['data'] as Map<String, dynamic>?
  ..message = json['message'] as String;

Map<String, dynamic> _$A2AInvalidRequestErrorToJson(
  A2AInvalidRequestError instance,
) => <String, dynamic>{
  'code': instance.code,
  'data': instance.data,
  'message': instance.message,
};

A2AMethodNotFoundError _$A2AMethodNotFoundErrorFromJson(
  Map<String, dynamic> json,
) => A2AMethodNotFoundError()
  ..data = json['data'] as Map<String, dynamic>?
  ..message = json['message'] as String;

Map<String, dynamic> _$A2AMethodNotFoundErrorToJson(
  A2AMethodNotFoundError instance,
) => <String, dynamic>{
  'code': instance.code,
  'data': instance.data,
  'message': instance.message,
};

A2AInvalidParamsError _$A2AInvalidParamsErrorFromJson(
  Map<String, dynamic> json,
) => A2AInvalidParamsError()
  ..data = json['data'] as Map<String, dynamic>?
  ..message = json['message'] as String;

Map<String, dynamic> _$A2AInvalidParamsErrorToJson(
  A2AInvalidParamsError instance,
) => <String, dynamic>{
  'code': instance.code,
  'data': instance.data,
  'message': instance.message,
};

A2AInternalError _$A2AInternalErrorFromJson(Map<String, dynamic> json) =>
    A2AInternalError()
      ..data = json['data'] as Map<String, dynamic>?
      ..message = json['message'] as String;

Map<String, dynamic> _$A2AInternalErrorToJson(A2AInternalError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'message': instance.message,
    };

A2ATaskNotFoundError _$A2ATaskNotFoundErrorFromJson(
  Map<String, dynamic> json,
) => A2ATaskNotFoundError()
  ..data = json['data'] as Map<String, dynamic>?
  ..message = json['message'] as String;

Map<String, dynamic> _$A2ATaskNotFoundErrorToJson(
  A2ATaskNotFoundError instance,
) => <String, dynamic>{
  'code': instance.code,
  'data': instance.data,
  'message': instance.message,
};

A2ATaskNotCancelableError _$A2ATaskNotCancelableErrorFromJson(
  Map<String, dynamic> json,
) => A2ATaskNotCancelableError()
  ..data = json['data'] as Map<String, dynamic>?
  ..message = json['message'] as String;

Map<String, dynamic> _$A2ATaskNotCancelableErrorToJson(
  A2ATaskNotCancelableError instance,
) => <String, dynamic>{
  'code': instance.code,
  'data': instance.data,
  'message': instance.message,
};

A2APushNotificationNotSupportedError
_$A2APushNotificationNotSupportedErrorFromJson(Map<String, dynamic> json) =>
    A2APushNotificationNotSupportedError()
      ..data = json['data'] as Map<String, dynamic>?
      ..message = json['message'] as String;

Map<String, dynamic> _$A2APushNotificationNotSupportedErrorToJson(
  A2APushNotificationNotSupportedError instance,
) => <String, dynamic>{
  'code': instance.code,
  'data': instance.data,
  'message': instance.message,
};

A2AUnsupportedOperationError _$A2AUnsupportedOperationErrorFromJson(
  Map<String, dynamic> json,
) => A2AUnsupportedOperationError()
  ..data = json['data'] as Map<String, dynamic>?
  ..message = json['message'] as String;

Map<String, dynamic> _$A2AUnsupportedOperationErrorToJson(
  A2AUnsupportedOperationError instance,
) => <String, dynamic>{
  'code': instance.code,
  'data': instance.data,
  'message': instance.message,
};

A2AContentTypeNotSupportedError _$A2AContentTypeNotSupportedErrorFromJson(
  Map<String, dynamic> json,
) => A2AContentTypeNotSupportedError()
  ..data = json['data'] as Map<String, dynamic>?
  ..message = json['message'] as String;

Map<String, dynamic> _$A2AContentTypeNotSupportedErrorToJson(
  A2AContentTypeNotSupportedError instance,
) => <String, dynamic>{
  'code': instance.code,
  'data': instance.data,
  'message': instance.message,
};

A2AInvalidAgentResponseError _$A2AInvalidAgentResponseErrorFromJson(
  Map<String, dynamic> json,
) => A2AInvalidAgentResponseError()
  ..data = json['data'] as Map<String, dynamic>?
  ..message = json['message'] as String;

Map<String, dynamic> _$A2AInvalidAgentResponseErrorToJson(
  A2AInvalidAgentResponseError instance,
) => <String, dynamic>{
  'code': instance.code,
  'data': instance.data,
  'message': instance.message,
};

A2AAuthenticatedExtendedCardNotConfiguredError
_$A2AAuthenticatedExtendedCardNotConfiguredErrorFromJson(
  Map<String, dynamic> json,
) => A2AAuthenticatedExtendedCardNotConfiguredError()
  ..data = json['data'] as Map<String, dynamic>?
  ..message = json['message'] as String;

Map<String, dynamic> _$A2AAuthenticatedExtendedCardNotConfiguredErrorToJson(
  A2AAuthenticatedExtendedCardNotConfiguredError instance,
) => <String, dynamic>{
  'code': instance.code,
  'data': instance.data,
  'message': instance.message,
};

A2ASendMessageRequest _$A2ASendMessageRequestFromJson(
  Map<String, dynamic> json,
) => A2ASendMessageRequest()
  ..id = json['id']
  ..params = json['params'] == null
      ? null
      : A2AMessageSendParams.fromJson(json['params'] as Map<String, dynamic>);

Map<String, dynamic> _$A2ASendMessageRequestToJson(
  A2ASendMessageRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
  'method': instance.method,
  'params': instance.params?.toJson(),
};

A2ASendStreamingMessageRequest _$A2ASendStreamingMessageRequestFromJson(
  Map<String, dynamic> json,
) => A2ASendStreamingMessageRequest()
  ..id = json['id']
  ..params = json['params'] == null
      ? null
      : A2AMessageSendParams.fromJson(json['params'] as Map<String, dynamic>);

Map<String, dynamic> _$A2ASendStreamingMessageRequestToJson(
  A2ASendStreamingMessageRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
  'method': instance.method,
  'params': instance.params?.toJson(),
};

A2AGetTaskRequest _$A2AGetTaskRequestFromJson(Map<String, dynamic> json) =>
    A2AGetTaskRequest()
      ..id = json['id']
      ..params = json['params'] == null
          ? null
          : A2ATaskQueryParams.fromJson(json['params'] as Map<String, dynamic>);

Map<String, dynamic> _$A2AGetTaskRequestToJson(A2AGetTaskRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jsonrpc': instance.jsonrpc,
      'method': instance.method,
      'params': instance.params?.toJson(),
    };

A2ACancelTaskRequest _$A2ACancelTaskRequestFromJson(
  Map<String, dynamic> json,
) => A2ACancelTaskRequest()
  ..id = json['id']
  ..params = json['params'] == null
      ? null
      : A2ATaskIdParams.fromJson(json['params'] as Map<String, dynamic>);

Map<String, dynamic> _$A2ACancelTaskRequestToJson(
  A2ACancelTaskRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
  'method': instance.method,
  'params': instance.params?.toJson(),
};

A2ASetTaskPushNotificationConfigRequest
_$A2ASetTaskPushNotificationConfigRequestFromJson(Map<String, dynamic> json) =>
    A2ASetTaskPushNotificationConfigRequest()
      ..id = json['id']
      ..params = json['params'] == null
          ? null
          : A2ATaskPushNotificationConfig.fromJson(
              json['params'] as Map<String, dynamic>,
            );

Map<String, dynamic> _$A2ASetTaskPushNotificationConfigRequestToJson(
  A2ASetTaskPushNotificationConfigRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
  'method': instance.method,
  'params': instance.params?.toJson(),
};

A2AGetTaskPushNotificationConfigRequest
_$A2AGetTaskPushNotificationConfigRequestFromJson(Map<String, dynamic> json) =>
    A2AGetTaskPushNotificationConfigRequest()
      ..id = json['id']
      ..params = json['params'] == null
          ? null
          : A2AGetTaskPushNotificationConfigParams.fromJson(
              json['params'] as Map<String, dynamic>,
            );

Map<String, dynamic> _$A2AGetTaskPushNotificationConfigRequestToJson(
  A2AGetTaskPushNotificationConfigRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
  'method': instance.method,
  'params': instance.params?.toJson(),
};

A2ADeleteTaskPushNotificationConfigRequest
_$A2ADeleteTaskPushNotificationConfigRequestFromJson(
  Map<String, dynamic> json,
) => A2ADeleteTaskPushNotificationConfigRequest()
  ..id = json['id']
  ..params = json['params'] == null
      ? null
      : A2ADeleteTaskPushNotificationConfigParams.fromJson(
          json['params'] as Map<String, dynamic>,
        );

Map<String, dynamic> _$A2ADeleteTaskPushNotificationConfigRequestToJson(
  A2ADeleteTaskPushNotificationConfigRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
  'method': instance.method,
  'params': instance.params?.toJson(),
};

A2AListTaskPushNotificationConfigRequest
_$A2AListTaskPushNotificationConfigRequestFromJson(Map<String, dynamic> json) =>
    A2AListTaskPushNotificationConfigRequest()
      ..id = json['id']
      ..params = json['params'] == null
          ? null
          : A2AListTaskPushNotificationConfigParams.fromJson(
              json['params'] as Map<String, dynamic>,
            );

Map<String, dynamic> _$A2AListTaskPushNotificationConfigRequestToJson(
  A2AListTaskPushNotificationConfigRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
  'method': instance.method,
  'params': instance.params?.toJson(),
};

A2ATaskResubscriptionRequest _$A2ATaskResubscriptionRequestFromJson(
  Map<String, dynamic> json,
) => A2ATaskResubscriptionRequest()
  ..id = json['id']
  ..params = json['params'] == null
      ? null
      : A2ATaskIdParams.fromJson(json['params'] as Map<String, dynamic>);

Map<String, dynamic> _$A2ATaskResubscriptionRequestToJson(
  A2ATaskResubscriptionRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
  'method': instance.method,
  'params': instance.params?.toJson(),
};

A2ATaskPushNotificationConfig _$A2ATaskPushNotificationConfigFromJson(
  Map<String, dynamic> json,
) => A2ATaskPushNotificationConfig()
  ..pushNotificationConfig = json['pushNotificationConfig'] == null
      ? null
      : A2APushNotificationConfig.fromJson(
          json['pushNotificationConfig'] as Map<String, dynamic>,
        )
  ..taskId = json['taskId'] as String;

Map<String, dynamic> _$A2ATaskPushNotificationConfigToJson(
  A2ATaskPushNotificationConfig instance,
) => <String, dynamic>{
  'pushNotificationConfig': instance.pushNotificationConfig?.toJson(),
  'taskId': instance.taskId,
};

A2ATaskIdParams _$A2ATaskIdParamsFromJson(Map<String, dynamic> json) =>
    A2ATaskIdParams()
      ..id = json['id'] as String
      ..metadata = json['metadata'] as Map<String, dynamic>?;

Map<String, dynamic> _$A2ATaskIdParamsToJson(A2ATaskIdParams instance) =>
    <String, dynamic>{'id': instance.id, 'metadata': instance.metadata};

A2ATaskQueryParams _$A2ATaskQueryParamsFromJson(Map<String, dynamic> json) =>
    A2ATaskQueryParams()
      ..historyLength = (json['historyLength'] as num?)?.toInt()
      ..id = json['id'] as String
      ..metadata = json['metadata'] as Map<String, dynamic>?;

Map<String, dynamic> _$A2ATaskQueryParamsToJson(A2ATaskQueryParams instance) =>
    <String, dynamic>{
      'historyLength': instance.historyLength,
      'id': instance.id,
      'metadata': instance.metadata,
    };

A2AMessageSendParams _$A2AMessageSendParamsFromJson(
  Map<String, dynamic> json,
) => A2AMessageSendParams()
  ..configuration = json['configuration'] == null
      ? null
      : A2AMessageSendConfiguration.fromJson(
          json['configuration'] as Map<String, dynamic>,
        )
  ..message = A2AMessage.fromJson(json['message'] as Map<String, dynamic>)
  ..metadata = json['metadata'] as Map<String, dynamic>?;

Map<String, dynamic> _$A2AMessageSendParamsToJson(
  A2AMessageSendParams instance,
) => <String, dynamic>{
  'configuration': instance.configuration?.toJson(),
  'message': instance.message.toJson(),
  'metadata': instance.metadata,
};

A2AMessageSendConfiguration _$A2AMessageSendConfigurationFromJson(
  Map<String, dynamic> json,
) => A2AMessageSendConfiguration()
  ..acceptedOutputModes = (json['acceptedOutputModes'] as List<dynamic>)
      .map((e) => e as String)
      .toList()
  ..blocking = json['blocking'] as bool?
  ..historyLength = json['historyLength'] as num?
  ..pushNotificationConfig = json['pushNotificationConfig'] == null
      ? null
      : A2APushNotificationConfig.fromJson(
          json['pushNotificationConfig'] as Map<String, dynamic>,
        );

Map<String, dynamic> _$A2AMessageSendConfigurationToJson(
  A2AMessageSendConfiguration instance,
) => <String, dynamic>{
  'acceptedOutputModes': instance.acceptedOutputModes,
  'blocking': instance.blocking,
  'historyLength': instance.historyLength,
  'pushNotificationConfig': instance.pushNotificationConfig?.toJson(),
};

A2APushNotificationConfig _$A2APushNotificationConfigFromJson(
  Map<String, dynamic> json,
) => A2APushNotificationConfig()
  ..authentication = json['authentication'] == null
      ? null
      : A2APushNotificationAuthenticationInfo.fromJson(
          json['authentication'] as Map<String, dynamic>,
        )
  ..id = json['id'] as String?
  ..token = json['token'] as String?
  ..url = json['url'] as String;

Map<String, dynamic> _$A2APushNotificationConfigToJson(
  A2APushNotificationConfig instance,
) => <String, dynamic>{
  'authentication': instance.authentication?.toJson(),
  'id': instance.id,
  'token': instance.token,
  'url': instance.url,
};

A2APushNotificationAuthenticationInfo
_$A2APushNotificationAuthenticationInfoFromJson(Map<String, dynamic> json) =>
    A2APushNotificationAuthenticationInfo()
      ..credentials = json['credentials'] as String?
      ..schemes = (json['schemes'] as List<dynamic>)
          .map((e) => e as String)
          .toList();

Map<String, dynamic> _$A2APushNotificationAuthenticationInfoToJson(
  A2APushNotificationAuthenticationInfo instance,
) => <String, dynamic>{
  'credentials': instance.credentials,
  'schemes': instance.schemes,
};

A2AListTaskPushNotificationConfigParams
_$A2AListTaskPushNotificationConfigParamsFromJson(Map<String, dynamic> json) =>
    A2AListTaskPushNotificationConfigParams()
      ..id = json['id'] as String
      ..metadata = json['metadata'] as Map<String, dynamic>?;

Map<String, dynamic> _$A2AListTaskPushNotificationConfigParamsToJson(
  A2AListTaskPushNotificationConfigParams instance,
) => <String, dynamic>{'id': instance.id, 'metadata': instance.metadata};

A2AGetTaskPushNotificationConfigParams
_$A2AGetTaskPushNotificationConfigParamsFromJson(Map<String, dynamic> json) =>
    A2AGetTaskPushNotificationConfigParams()
      ..id = json['id'] as String
      ..metadata = json['metadata'] as Map<String, dynamic>?
      ..pushNotificationConfigId = json['pushNotificationConfigId'] as String?;

Map<String, dynamic> _$A2AGetTaskPushNotificationConfigParamsToJson(
  A2AGetTaskPushNotificationConfigParams instance,
) => <String, dynamic>{
  'id': instance.id,
  'metadata': instance.metadata,
  'pushNotificationConfigId': instance.pushNotificationConfigId,
};

A2ADeleteTaskPushNotificationConfigParams
_$A2ADeleteTaskPushNotificationConfigParamsFromJson(
  Map<String, dynamic> json,
) => A2ADeleteTaskPushNotificationConfigParams()
  ..id = json['id'] as String
  ..metadata = json['metadata'] as Map<String, dynamic>?
  ..pushNotificationConfigId = json['pushNotificationConfigId'] as String;

Map<String, dynamic> _$A2ADeleteTaskPushNotificationConfigParamsToJson(
  A2ADeleteTaskPushNotificationConfigParams instance,
) => <String, dynamic>{
  'id': instance.id,
  'metadata': instance.metadata,
  'pushNotificationConfigId': instance.pushNotificationConfigId,
};

A2ATextPart _$A2ATextPartFromJson(Map<String, dynamic> json) => A2ATextPart()
  ..metadata = json['metadata'] as Map<String, dynamic>?
  ..text = json['text'] as String;

Map<String, dynamic> _$A2ATextPartToJson(A2ATextPart instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'metadata': instance.metadata,
      'text': instance.text,
    };

A2AFilePart _$A2AFilePartFromJson(Map<String, dynamic> json) => A2AFilePart()
  ..metadata = json['metadata'] as Map<String, dynamic>?
  ..file = json['file'] == null
      ? null
      : A2AFilePartVariant.fromJson(json['file'] as Map<String, dynamic>);

Map<String, dynamic> _$A2AFilePartToJson(A2AFilePart instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'metadata': instance.metadata,
      'file': instance.file?.toJson(),
    };

A2ADataPart _$A2ADataPartFromJson(Map<String, dynamic> json) => A2ADataPart()
  ..data = json['data'] as Map<String, dynamic>
  ..metadata = json['metadata'] as Map<String, dynamic>?;

Map<String, dynamic> _$A2ADataPartToJson(A2ADataPart instance) =>
    <String, dynamic>{
      'data': instance.data,
      'kind': instance.kind,
      'metadata': instance.metadata,
    };

A2AFileWithBytes _$A2AFileWithBytesFromJson(Map<String, dynamic> json) =>
    A2AFileWithBytes()
      ..bytes = json['bytes'] as String
      ..mimeType = json['mimeType'] as String
      ..name = json['name'] as String;

Map<String, dynamic> _$A2AFileWithBytesToJson(A2AFileWithBytes instance) =>
    <String, dynamic>{
      'bytes': instance.bytes,
      'mimeType': instance.mimeType,
      'name': instance.name,
    };

A2AFileWithUri _$A2AFileWithUriFromJson(Map<String, dynamic> json) =>
    A2AFileWithUri()
      ..mimeType = json['mimeType'] as String
      ..name = json['name'] as String
      ..uri = json['uri'] as String;

Map<String, dynamic> _$A2AFileWithUriToJson(A2AFileWithUri instance) =>
    <String, dynamic>{
      'mimeType': instance.mimeType,
      'name': instance.name,
      'uri': instance.uri,
    };

A2AAPIKeySecurityScheme _$A2AAPIKeySecuritySchemeFromJson(
  Map<String, dynamic> json,
) => A2AAPIKeySecurityScheme()
  ..description = json['description'] as String?
  ..location = json['location'] as String
  ..name = json['name'] as String?;

Map<String, dynamic> _$A2AAPIKeySecuritySchemeToJson(
  A2AAPIKeySecurityScheme instance,
) => <String, dynamic>{
  'description': instance.description,
  'location': instance.location,
  'name': instance.name,
  'type': instance.type,
};

A2AHTTPAuthSecurityScheme _$A2AHTTPAuthSecuritySchemeFromJson(
  Map<String, dynamic> json,
) => A2AHTTPAuthSecurityScheme()
  ..headerFormat = json['headerFormat'] as String?
  ..description = json['description'] as String?
  ..scheme = json['scheme'] as String;

Map<String, dynamic> _$A2AHTTPAuthSecuritySchemeToJson(
  A2AHTTPAuthSecurityScheme instance,
) => <String, dynamic>{
  'headerFormat': instance.headerFormat,
  'description': instance.description,
  'scheme': instance.scheme,
  'type': instance.type,
};

A2AOAuth2SecurityScheme _$A2AOAuth2SecuritySchemeFromJson(
  Map<String, dynamic> json,
) => A2AOAuth2SecurityScheme()
  ..description = json['description'] as String?
  ..flows = json['flows'] == null
      ? null
      : A2AOAuthFlows.fromJson(json['flows'] as Map<String, dynamic>);

Map<String, dynamic> _$A2AOAuth2SecuritySchemeToJson(
  A2AOAuth2SecurityScheme instance,
) => <String, dynamic>{
  'description': instance.description,
  'flows': instance.flows?.toJson(),
  'type': instance.type,
};

A2AOpenIdConnectSecurityScheme _$A2AOpenIdConnectSecuritySchemeFromJson(
  Map<String, dynamic> json,
) => A2AOpenIdConnectSecurityScheme()
  ..description = json['description'] as String?
  ..openIdConnectUrl = json['openIdConnectUrl'] as String;

Map<String, dynamic> _$A2AOpenIdConnectSecuritySchemeToJson(
  A2AOpenIdConnectSecurityScheme instance,
) => <String, dynamic>{
  'description': instance.description,
  'openIdConnectUrl': instance.openIdConnectUrl,
  'type': instance.type,
};

A2AOAuthFlows _$A2AOAuthFlowsFromJson(
  Map<String, dynamic> json,
) => A2AOAuthFlows()
  ..authorizationCode = json['authorizationCode'] == null
      ? null
      : A2AAuthorizationCodeOAuthFlow.fromJson(
          json['authorizationCode'] as Map<String, dynamic>,
        )
  ..clientCredentials = json['clientCredentials'] == null
      ? null
      : A2AClientCredentialsOAuthFlow.fromJson(
          json['clientCredentials'] as Map<String, dynamic>,
        )
  ..implicit = json['implicit'] == null
      ? null
      : A2AImplicitOAuthFlow.fromJson(json['implicit'] as Map<String, dynamic>)
  ..password = json['password'] == null
      ? null
      : A2APasswordOAuthFlow.fromJson(json['password'] as Map<String, dynamic>);

Map<String, dynamic> _$A2AOAuthFlowsToJson(A2AOAuthFlows instance) =>
    <String, dynamic>{
      'authorizationCode': instance.authorizationCode?.toJson(),
      'clientCredentials': instance.clientCredentials?.toJson(),
      'implicit': instance.implicit?.toJson(),
      'password': instance.password?.toJson(),
    };

A2AImplicitOAuthFlow _$A2AImplicitOAuthFlowFromJson(
  Map<String, dynamic> json,
) => A2AImplicitOAuthFlow()
  ..authorizationUrl = json['authorizationUrl'] as String
  ..refreshUrl = json['refreshUrl'] as String?
  ..scopes = Map<String, String>.from(json['scopes'] as Map);

Map<String, dynamic> _$A2AImplicitOAuthFlowToJson(
  A2AImplicitOAuthFlow instance,
) => <String, dynamic>{
  'authorizationUrl': instance.authorizationUrl,
  'refreshUrl': instance.refreshUrl,
  'scopes': instance.scopes,
};

A2AAuthorizationCodeOAuthFlow _$A2AAuthorizationCodeOAuthFlowFromJson(
  Map<String, dynamic> json,
) => A2AAuthorizationCodeOAuthFlow()
  ..authorizationUrl = json['authorizationUrl'] as String
  ..refreshUrl = json['refreshUrl'] as String?
  ..scopes = Map<String, String>.from(json['scopes'] as Map)
  ..tokenUrl = json['tokenUrl'] as String;

Map<String, dynamic> _$A2AAuthorizationCodeOAuthFlowToJson(
  A2AAuthorizationCodeOAuthFlow instance,
) => <String, dynamic>{
  'authorizationUrl': instance.authorizationUrl,
  'refreshUrl': instance.refreshUrl,
  'scopes': instance.scopes,
  'tokenUrl': instance.tokenUrl,
};

A2AClientCredentialsOAuthFlow _$A2AClientCredentialsOAuthFlowFromJson(
  Map<String, dynamic> json,
) => A2AClientCredentialsOAuthFlow()
  ..refreshUrl = json['refreshUrl'] as String
  ..scopes = Map<String, String>.from(json['scopes'] as Map)
  ..tokenUrl = json['tokenUrl'] as String;

Map<String, dynamic> _$A2AClientCredentialsOAuthFlowToJson(
  A2AClientCredentialsOAuthFlow instance,
) => <String, dynamic>{
  'refreshUrl': instance.refreshUrl,
  'scopes': instance.scopes,
  'tokenUrl': instance.tokenUrl,
};

A2APasswordOAuthFlow _$A2APasswordOAuthFlowFromJson(
  Map<String, dynamic> json,
) => A2APasswordOAuthFlow()
  ..refreshUrl = json['refreshUrl'] as String
  ..scopes = Map<String, String>.from(json['scopes'] as Map)
  ..tokenUrl = json['tokenUrl'] as String;

Map<String, dynamic> _$A2APasswordOAuthFlowToJson(
  A2APasswordOAuthFlow instance,
) => <String, dynamic>{
  'refreshUrl': instance.refreshUrl,
  'scopes': instance.scopes,
  'tokenUrl': instance.tokenUrl,
};

A2AJSONRPCErrorResponse _$A2AJSONRPCErrorResponseFromJson(
  Map<String, dynamic> json,
) => A2AJSONRPCErrorResponse()
  ..error = json['error'] == null
      ? null
      : A2AError.fromJson(json['error'] as Map<String, dynamic>)
  ..id = json['id'];

Map<String, dynamic> _$A2AJSONRPCErrorResponseToJson(
  A2AJSONRPCErrorResponse instance,
) => <String, dynamic>{
  'error': instance.error?.toJson(),
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
};

A2ACancelTaskSuccessResponse _$A2ACancelTaskSuccessResponseFromJson(
  Map<String, dynamic> json,
) => A2ACancelTaskSuccessResponse()
  ..id = json['id']
  ..result = json['result'] == null
      ? null
      : A2ATask.fromJson(json['result'] as Map<String, dynamic>);

Map<String, dynamic> _$A2ACancelTaskSuccessResponseToJson(
  A2ACancelTaskSuccessResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
  'result': instance.result?.toJson(),
};

A2AJSONRPCErrorResponseGTPR _$A2AJSONRPCErrorResponseGTPRFromJson(
  Map<String, dynamic> json,
) => A2AJSONRPCErrorResponseGTPR()
  ..error = json['error'] == null
      ? null
      : A2AError.fromJson(json['error'] as Map<String, dynamic>)
  ..id = json['id'];

Map<String, dynamic> _$A2AJSONRPCErrorResponseGTPRToJson(
  A2AJSONRPCErrorResponseGTPR instance,
) => <String, dynamic>{
  'error': instance.error?.toJson(),
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
};

A2AGetTaskPushNotificationConfigSuccessResponse
_$A2AGetTaskPushNotificationConfigSuccessResponseFromJson(
  Map<String, dynamic> json,
) => A2AGetTaskPushNotificationConfigSuccessResponse()
  ..id = json['id']
  ..result = json['result'] == null
      ? null
      : A2ATaskPushNotificationConfig.fromJson(
          json['result'] as Map<String, dynamic>,
        );

Map<String, dynamic> _$A2AGetTaskPushNotificationConfigSuccessResponseToJson(
  A2AGetTaskPushNotificationConfigSuccessResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
  'result': instance.result?.toJson(),
};

A2AJSONRPCErrorResponseSTPR _$A2AJSONRPCErrorResponseSTPRFromJson(
  Map<String, dynamic> json,
) => A2AJSONRPCErrorResponseSTPR()
  ..error = json['error'] == null
      ? null
      : A2AError.fromJson(json['error'] as Map<String, dynamic>)
  ..id = json['id'];

Map<String, dynamic> _$A2AJSONRPCErrorResponseSTPRToJson(
  A2AJSONRPCErrorResponseSTPR instance,
) => <String, dynamic>{
  'error': instance.error?.toJson(),
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
};

A2ASetTaskPushNotificationConfigSuccessResponseSTPR
_$A2ASetTaskPushNotificationConfigSuccessResponseSTPRFromJson(
  Map<String, dynamic> json,
) => A2ASetTaskPushNotificationConfigSuccessResponseSTPR()
  ..id = json['id']
  ..result = json['result'] == null
      ? null
      : A2ATaskPushNotificationConfig.fromJson(
          json['result'] as Map<String, dynamic>,
        );

Map<String, dynamic>
_$A2ASetTaskPushNotificationConfigSuccessResponseSTPRToJson(
  A2ASetTaskPushNotificationConfigSuccessResponseSTPR instance,
) => <String, dynamic>{
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
  'result': instance.result?.toJson(),
};

A2AJSONRPCErrorResponseLTPR _$A2AJSONRPCErrorResponseLTPRFromJson(
  Map<String, dynamic> json,
) => A2AJSONRPCErrorResponseLTPR()
  ..error = json['error'] == null
      ? null
      : A2AError.fromJson(json['error'] as Map<String, dynamic>)
  ..id = json['id'];

Map<String, dynamic> _$A2AJSONRPCErrorResponseLTPRToJson(
  A2AJSONRPCErrorResponseLTPR instance,
) => <String, dynamic>{
  'error': instance.error?.toJson(),
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
};

A2AListTaskPushNotificationConfigSuccessResponse
_$A2AListTaskPushNotificationConfigSuccessResponseFromJson(
  Map<String, dynamic> json,
) => A2AListTaskPushNotificationConfigSuccessResponse()
  ..id = json['id']
  ..result = (json['result'] as List<dynamic>?)
      ?.map(
        (e) =>
            A2ATaskPushNotificationConfig.fromJson(e as Map<String, dynamic>),
      )
      .toList();

Map<String, dynamic> _$A2AListTaskPushNotificationConfigSuccessResponseToJson(
  A2AListTaskPushNotificationConfigSuccessResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
  'result': instance.result?.map((e) => e.toJson()).toList(),
};

A2AJSONRPCErrorResponseDTPR _$A2AJSONRPCErrorResponseDTPRFromJson(
  Map<String, dynamic> json,
) => A2AJSONRPCErrorResponseDTPR()
  ..error = json['error'] == null
      ? null
      : A2AError.fromJson(json['error'] as Map<String, dynamic>)
  ..id = json['id'];

Map<String, dynamic> _$A2AJSONRPCErrorResponseDTPRToJson(
  A2AJSONRPCErrorResponseDTPR instance,
) => <String, dynamic>{
  'error': instance.error?.toJson(),
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
};

A2ADeleteTaskPushNotificationConfigSuccessResponse
_$A2ADeleteTaskPushNotificationConfigSuccessResponseFromJson(
  Map<String, dynamic> json,
) => A2ADeleteTaskPushNotificationConfigSuccessResponse()
  ..id = json['id']
  ..result = json['result'];

Map<String, dynamic> _$A2ADeleteTaskPushNotificationConfigSuccessResponseToJson(
  A2ADeleteTaskPushNotificationConfigSuccessResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
  'result': instance.result,
};

A2AJSONRPCErrorResponseT _$A2AJSONRPCErrorResponseTFromJson(
  Map<String, dynamic> json,
) => A2AJSONRPCErrorResponseT()
  ..error = json['error'] == null
      ? null
      : A2AError.fromJson(json['error'] as Map<String, dynamic>)
  ..id = json['id'];

Map<String, dynamic> _$A2AJSONRPCErrorResponseTToJson(
  A2AJSONRPCErrorResponseT instance,
) => <String, dynamic>{
  'error': instance.error?.toJson(),
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
};

A2AGetTaskSuccessResponse _$A2AGetTaskSuccessResponseFromJson(
  Map<String, dynamic> json,
) => A2AGetTaskSuccessResponse()
  ..id = json['id']
  ..result = json['result'] == null
      ? null
      : A2ATask.fromJson(json['result'] as Map<String, dynamic>);

Map<String, dynamic> _$A2AGetTaskSuccessResponseToJson(
  A2AGetTaskSuccessResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
  'result': instance.result?.toJson(),
};

A2AJSONRPCErrorResponseS _$A2AJSONRPCErrorResponseSFromJson(
  Map<String, dynamic> json,
) => A2AJSONRPCErrorResponseS()
  ..error = json['error'] == null
      ? null
      : A2AError.fromJson(json['error'] as Map<String, dynamic>)
  ..id = json['id'];

Map<String, dynamic> _$A2AJSONRPCErrorResponseSToJson(
  A2AJSONRPCErrorResponseS instance,
) => <String, dynamic>{
  'error': instance.error?.toJson(),
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
};

A2AJSONRPCErrorResponseSS _$A2AJSONRPCErrorResponseSSFromJson(
  Map<String, dynamic> json,
) => A2AJSONRPCErrorResponseSS()
  ..error = json['error'] == null
      ? null
      : A2AError.fromJson(json['error'] as Map<String, dynamic>)
  ..id = json['id'];

Map<String, dynamic> _$A2AJSONRPCErrorResponseSSToJson(
  A2AJSONRPCErrorResponseSS instance,
) => <String, dynamic>{
  'error': instance.error?.toJson(),
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
};

A2AJSONRPCErrorResponsePNCR _$A2AJSONRPCErrorResponsePNCRFromJson(
  Map<String, dynamic> json,
) => A2AJSONRPCErrorResponsePNCR()
  ..error = json['error'] == null
      ? null
      : A2AError.fromJson(json['error'] as Map<String, dynamic>)
  ..id = json['id'];

Map<String, dynamic> _$A2AJSONRPCErrorResponsePNCRToJson(
  A2AJSONRPCErrorResponsePNCR instance,
) => <String, dynamic>{
  'error': instance.error?.toJson(),
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
};

A2ASendMessageSuccessResponse _$A2ASendMessageSuccessResponseFromJson(
  Map<String, dynamic> json,
) => A2ASendMessageSuccessResponse()
  ..id = json['id']
  ..result = json['result'];

Map<String, dynamic> _$A2ASendMessageSuccessResponseToJson(
  A2ASendMessageSuccessResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
  'result': instance.result,
};

A2ASendStreamingMessageSuccessResponse
_$A2ASendStreamingMessageSuccessResponseFromJson(Map<String, dynamic> json) =>
    A2ASendStreamingMessageSuccessResponse()
      ..id = json['id']
      ..result = json['result'];

Map<String, dynamic> _$A2ASendStreamingMessageSuccessResponseToJson(
  A2ASendStreamingMessageSuccessResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
  'result': instance.result,
};

A2ASetTaskPushNotificationConfigSuccessResponse
_$A2ASetTaskPushNotificationConfigSuccessResponseFromJson(
  Map<String, dynamic> json,
) => A2ASetTaskPushNotificationConfigSuccessResponse()
  ..id = json['id']
  ..result = json['result'] == null
      ? null
      : A2APushNotificationConfig.fromJson(
          json['result'] as Map<String, dynamic>,
        );

Map<String, dynamic> _$A2ASetTaskPushNotificationConfigSuccessResponseToJson(
  A2ASetTaskPushNotificationConfigSuccessResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
  'result': instance.result?.toJson(),
};

A2AJSONRPCErrorResponseSSM _$A2AJSONRPCErrorResponseSSMFromJson(
  Map<String, dynamic> json,
) => A2AJSONRPCErrorResponseSSM()
  ..error = json['error'] == null
      ? null
      : A2AError.fromJson(json['error'] as Map<String, dynamic>)
  ..id = json['id'];

Map<String, dynamic> _$A2AJSONRPCErrorResponseSSMToJson(
  A2AJSONRPCErrorResponseSSM instance,
) => <String, dynamic>{
  'error': instance.error?.toJson(),
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
};

A2ASendStreamMessageSuccessResponse
_$A2ASendStreamMessageSuccessResponseFromJson(Map<String, dynamic> json) =>
    A2ASendStreamMessageSuccessResponse()
      ..id = json['id']
      ..result = json['result'];

Map<String, dynamic> _$A2ASendStreamMessageSuccessResponseToJson(
  A2ASendStreamMessageSuccessResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
  'result': instance.result,
};

A2ATaskStatusUpdateEvent _$A2ATaskStatusUpdateEventFromJson(
  Map<String, dynamic> json,
) => A2ATaskStatusUpdateEvent()
  ..contextId = json['contextId'] as String
  ..end = json['end'] as bool?
  ..metadata = json['metadata'] as Map<String, dynamic>?
  ..status = json['status'] == null
      ? null
      : A2ATaskStatus.fromJson(json['status'] as Map<String, dynamic>)
  ..taskId = json['taskId'] as String;

Map<String, dynamic> _$A2ATaskStatusUpdateEventToJson(
  A2ATaskStatusUpdateEvent instance,
) => <String, dynamic>{
  'contextId': instance.contextId,
  'end': instance.end,
  'kind': instance.kind,
  'metadata': instance.metadata,
  'status': instance.status?.toJson(),
  'taskId': instance.taskId,
};

A2ATaskArtifactUpdateEvent _$A2ATaskArtifactUpdateEventFromJson(
  Map<String, dynamic> json,
) => A2ATaskArtifactUpdateEvent()
  ..append = json['append'] as bool?
  ..artifact = json['artifact'] == null
      ? null
      : A2AArtifact.fromJson(json['artifact'] as Map<String, dynamic>)
  ..contextId = json['contextId'] as String
  ..lastChunk = json['lastChunk'] as bool?
  ..metadata = json['metadata'] as Map<String, dynamic>?
  ..taskId = json['taskId'] as String;

Map<String, dynamic> _$A2ATaskArtifactUpdateEventToJson(
  A2ATaskArtifactUpdateEvent instance,
) => <String, dynamic>{
  'append': instance.append,
  'artifact': instance.artifact?.toJson(),
  'contextId': instance.contextId,
  'kind': instance.kind,
  'lastChunk': instance.lastChunk,
  'metadata': instance.metadata,
  'taskId': instance.taskId,
};

A2AAgentCapabilities _$A2AAgentCapabilitiesFromJson(
  Map<String, dynamic> json,
) => A2AAgentCapabilities()
  ..extensions = (json['extensions'] as List<dynamic>?)
      ?.map((e) => A2AAgentExtension.fromJson(e as Map<String, dynamic>))
      .toList()
  ..pushNotifications = json['pushNotifications'] as bool?
  ..stateTransitionHistory = json['stateTransitionHistory'] as bool?
  ..streaming = json['streaming'] as bool?;

Map<String, dynamic> _$A2AAgentCapabilitiesToJson(
  A2AAgentCapabilities instance,
) => <String, dynamic>{
  'extensions': instance.extensions?.map((e) => e.toJson()).toList(),
  'pushNotifications': instance.pushNotifications,
  'stateTransitionHistory': instance.stateTransitionHistory,
  'streaming': instance.streaming,
};

A2AAgentExtension _$A2AAgentExtensionFromJson(Map<String, dynamic> json) =>
    A2AAgentExtension()
      ..description = json['description'] as String?
      ..params = json['params'] as Map<String, dynamic>?
      ..required = json['required'] as bool?
      ..uri = json['uri'] as String;

Map<String, dynamic> _$A2AAgentExtensionToJson(A2AAgentExtension instance) =>
    <String, dynamic>{
      'description': instance.description,
      'params': instance.params,
      'required': instance.required,
      'uri': instance.uri,
    };

A2AAgentInterface _$A2AAgentInterfaceFromJson(Map<String, dynamic> json) =>
    A2AAgentInterface()
      ..url = json['url'] as String
      ..transport = $enumDecode(
        _$A2ATransportProtocolEnumMap,
        json['transport'],
      );

Map<String, dynamic> _$A2AAgentInterfaceToJson(A2AAgentInterface instance) =>
    <String, dynamic>{
      'url': instance.url,
      'transport': _$A2ATransportProtocolEnumMap[instance.transport]!,
    };

const _$A2ATransportProtocolEnumMap = {
  A2ATransportProtocol.jsonRpc: 'JSONRPC',
  A2ATransportProtocol.gRpc: 'GRPC',
  A2ATransportProtocol.httpJson: 'HTTP+JSON',
};

A2AAgentCardSignature _$A2AAgentCardSignatureFromJson(
  Map<String, dynamic> json,
) => A2AAgentCardSignature()
  ..protected = json['protected'] as String
  ..signature = json['signature'] as String
  ..header = json['header'] as Map<String, dynamic>?;

Map<String, dynamic> _$A2AAgentCardSignatureToJson(
  A2AAgentCardSignature instance,
) => <String, dynamic>{
  'protected': instance.protected,
  'signature': instance.signature,
  'header': instance.header,
};

A2AAgentCard _$A2AAgentCardFromJson(Map<String, dynamic> json) => A2AAgentCard()
  ..protocolVersion = json['protocolVersion'] as String
  ..capabilities = A2AAgentCapabilities.fromJson(
    json['capabilities'] as Map<String, dynamic>,
  )
  ..defaultInputModes = (json['defaultInputModes'] as List<dynamic>)
      .map((e) => e as String)
      .toList()
  ..defaultOutputModes = (json['defaultOutputModes'] as List<dynamic>)
      .map((e) => e as String)
      .toList()
  ..description = json['description'] as String
  ..documentationUrl = json['documentationUrl'] as String?
  ..iconUrl = json['iconUrl'] as String?
  ..name = json['name'] as String
  ..agentProvider = json['agentProvider'] == null
      ? null
      : A2AAgentProvider.fromJson(json['agentProvider'] as Map<String, dynamic>)
  ..security = (json['security'] as List<dynamic>?)
      ?.map(
        (e) => (e as Map<String, dynamic>).map(
          (k, e) => MapEntry(
            k,
            (e as List<dynamic>).map((e) => e as String).toList(),
          ),
        ),
      )
      .toList()
  ..securitySchemes = (json['securitySchemes'] as Map<String, dynamic>?)?.map(
    (k, e) =>
        MapEntry(k, A2ASecurityScheme.fromJson(e as Map<String, dynamic>)),
  )
  ..skills = (json['skills'] as List<dynamic>)
      .map((e) => A2AAgentSkill.fromJson(e as Map<String, dynamic>))
      .toList()
  ..supportsAuthenticatedExtendedCard =
      json['supportsAuthenticatedExtendedCard'] as bool?
  ..url = json['url'] as String
  ..preferredTransport = $enumDecode(
    _$A2ATransportProtocolEnumMap,
    json['preferredTransport'],
  )
  ..additionalInterfaces = (json['additionalInterfaces'] as List<dynamic>?)
      ?.map((e) => A2AAgentInterface.fromJson(e as Map<String, dynamic>))
      .toList()
  ..signatures = (json['signatures'] as List<dynamic>?)
      ?.map((e) => A2AAgentCardSignature.fromJson(e as Map<String, dynamic>))
      .toList()
  ..version = json['version'] as String;

Map<String, dynamic> _$A2AAgentCardToJson(A2AAgentCard instance) =>
    <String, dynamic>{
      'protocolVersion': instance.protocolVersion,
      'capabilities': instance.capabilities.toJson(),
      'defaultInputModes': instance.defaultInputModes,
      'defaultOutputModes': instance.defaultOutputModes,
      'description': instance.description,
      'documentationUrl': instance.documentationUrl,
      'iconUrl': instance.iconUrl,
      'name': instance.name,
      'agentProvider': instance.agentProvider?.toJson(),
      'security': instance.security,
      'securitySchemes': instance.securitySchemes?.map(
        (k, e) => MapEntry(k, e.toJson()),
      ),
      'skills': instance.skills.map((e) => e.toJson()).toList(),
      'supportsAuthenticatedExtendedCard':
          instance.supportsAuthenticatedExtendedCard,
      'url': instance.url,
      'preferredTransport':
          _$A2ATransportProtocolEnumMap[instance.preferredTransport]!,
      'additionalInterfaces': instance.additionalInterfaces
          ?.map((e) => e.toJson())
          .toList(),
      'signatures': instance.signatures?.map((e) => e.toJson()).toList(),
      'version': instance.version,
    };

A2AAgentProvider _$A2AAgentProviderFromJson(Map<String, dynamic> json) =>
    A2AAgentProvider()
      ..organization = json['organization'] as String
      ..url = json['url'] as String;

Map<String, dynamic> _$A2AAgentProviderToJson(A2AAgentProvider instance) =>
    <String, dynamic>{
      'organization': instance.organization,
      'url': instance.url,
    };

A2AAgentSkill _$A2AAgentSkillFromJson(Map<String, dynamic> json) =>
    A2AAgentSkill()
      ..description = json['description'] as String
      ..examples = (json['examples'] as List<dynamic>)
          .map((e) => e as String)
          .toList()
      ..id = json['id'] as String
      ..inputModes = (json['inputModes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..name = json['name'] as String
      ..outputModes = (json['outputModes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..tags = (json['tags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList();

Map<String, dynamic> _$A2AAgentSkillToJson(A2AAgentSkill instance) =>
    <String, dynamic>{
      'description': instance.description,
      'examples': instance.examples,
      'id': instance.id,
      'inputModes': instance.inputModes,
      'name': instance.name,
      'outputModes': instance.outputModes,
      'tags': instance.tags,
    };
