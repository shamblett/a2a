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
  ..metadata = (json['metadata'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as Object),
  )
  ..parts = (json['parts'] as List<dynamic>?)
      ?.map((e) => A2APart.fromJson(e as Map<String, dynamic>))
      .toList()
  ..referenceTaskIds = (json['referenceTaskIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList()
  ..role = json['role'] as String
  ..taskId = json['taskId'] as String?;

Map<String, dynamic> _$A2AMessageToJson(A2AMessage instance) =>
    <String, dynamic>{
      'contextId': instance.contextId,
      'extensions': instance.extensions,
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
  ..extensions = (json['extensions'] as List<dynamic>)
      .map((e) => e as String)
      .toList()
  ..metadata = (json['metadata'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as Object),
  )
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
  ..artifacts = (json['artifacts'] as List<dynamic>)
      .map((e) => A2AArtifact.fromJson(e as Map<String, dynamic>))
      .toList()
  ..contextId = json['contextId'] as String
  ..history = (json['history'] as List<dynamic>?)
      ?.map((e) => A2AMessage.fromJson(e as Map<String, dynamic>))
      .toList()
  ..id = json['id'] as String
  ..metadata = (json['metadata'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as Object),
  )
  ..status = json['status'] == null
      ? null
      : A2ATaskStatus.fromJson(json['status'] as Map<String, dynamic>);

Map<String, dynamic> _$A2ATaskToJson(A2ATask instance) => <String, dynamic>{
  'artifacts': instance.artifacts.map((e) => e.toJson()).toList(),
  'contextId': instance.contextId,
  'history': instance.history?.map((e) => e.toJson()).toList(),
  'id': instance.id,
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

A2AJSONRPCError _$A2AJSONRPCErrorFromJson(Map<String, dynamic> json) =>
    A2AJSONRPCError()
      ..code = (json['code'] as num).toInt()
      ..data = (json['data'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as Object),
      )
      ..message = json['message'] as String;

Map<String, dynamic> _$A2AJSONRPCErrorToJson(A2AJSONRPCError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'message': instance.message,
    };

A2AJSONParseError _$A2AJSONParseErrorFromJson(Map<String, dynamic> json) =>
    A2AJSONParseError()
      ..code = (json['code'] as num).toInt()
      ..data = (json['data'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as Object),
      )
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
  ..code = (json['code'] as num).toInt()
  ..data = (json['data'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as Object),
  )
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
  ..code = (json['code'] as num).toInt()
  ..data = (json['data'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as Object),
  )
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
  ..code = (json['code'] as num).toInt()
  ..data = (json['data'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as Object),
  )
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
      ..code = (json['code'] as num).toInt()
      ..data = (json['data'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as Object),
      )
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
  ..code = (json['code'] as num).toInt()
  ..data = (json['data'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as Object),
  )
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
  ..code = (json['code'] as num).toInt()
  ..data = (json['data'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as Object),
  )
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
      ..code = (json['code'] as num).toInt()
      ..data = (json['data'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as Object),
      )
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
  ..code = (json['code'] as num).toInt()
  ..data = (json['data'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as Object),
  )
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
  ..code = (json['code'] as num).toInt()
  ..data = (json['data'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as Object),
  )
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
  ..code = (json['code'] as num).toInt()
  ..data = (json['data'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as Object),
  )
  ..message = json['message'] as String;

Map<String, dynamic> _$A2AInvalidAgentResponseErrorToJson(
  A2AInvalidAgentResponseError instance,
) => <String, dynamic>{
  'code': instance.code,
  'data': instance.data,
  'message': instance.message,
};

A2ATaskPushNotificationConfig1 _$A2ATaskPushNotificationConfig1FromJson(
  Map<String, dynamic> json,
) => A2ATaskPushNotificationConfig1()
  ..authentication = json['authentication'] == null
      ? null
      : A2APushNotificationAuthenticationInfo.fromJson(
          json['authentication'] as Map<String, dynamic>,
        )
  ..id = json['id'] as String
  ..token = json['token'] as String?
  ..url = json['url'] as String;

Map<String, dynamic> _$A2ATaskPushNotificationConfig1ToJson(
  A2ATaskPushNotificationConfig1 instance,
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

A2ATextPart _$A2ATextPartFromJson(Map<String, dynamic> json) => A2ATextPart()
  ..metadata = (json['metadata'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as Object),
  )
  ..text = json['text'] as String;

Map<String, dynamic> _$A2ATextPartToJson(A2ATextPart instance) =>
    <String, dynamic>{'metadata': instance.metadata, 'text': instance.text};

A2AFilePart _$A2AFilePartFromJson(Map<String, dynamic> json) => A2AFilePart()
  ..metadata = (json['metadata'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as Object),
  )
  ..file = json['file'] == null
      ? null
      : A2AFilePartVariant.fromJson(json['file'] as Map<String, dynamic>);

Map<String, dynamic> _$A2AFilePartToJson(A2AFilePart instance) =>
    <String, dynamic>{
      'metadata': instance.metadata,
      'file': instance.file?.toJson(),
    };

A2ADataPart _$A2ADataPartFromJson(Map<String, dynamic> json) => A2ADataPart()
  ..data = (json['data'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, e as Object),
  )
  ..metadata = (json['metadata'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as Object),
  );

Map<String, dynamic> _$A2ADataPartToJson(A2ADataPart instance) =>
    <String, dynamic>{'data': instance.data, 'metadata': instance.metadata};

A2AFileWithBytes _$A2AFileWithBytesFromJson(Map<String, dynamic> json) =>
    A2AFileWithBytes()
      ..bytes = json['bytes'] as String
      ..mimeTYpe = json['mimeTYpe'] as String
      ..name = json['name'] as String;

Map<String, dynamic> _$A2AFileWithBytesToJson(A2AFileWithBytes instance) =>
    <String, dynamic>{
      'bytes': instance.bytes,
      'mimeTYpe': instance.mimeTYpe,
      'name': instance.name,
    };

A2AFileWithUrl _$A2AFileWithUrlFromJson(Map<String, dynamic> json) =>
    A2AFileWithUrl()
      ..mimeTYpe = json['mimeTYpe'] as String
      ..name = json['name'] as String
      ..url = json['url'] as String;

Map<String, dynamic> _$A2AFileWithUrlToJson(A2AFileWithUrl instance) =>
    <String, dynamic>{
      'mimeTYpe': instance.mimeTYpe,
      'name': instance.name,
      'url': instance.url,
    };

A2AAPIKeySecurityScheme _$A2AAPIKeySecuritySchemeFromJson(
  Map<String, dynamic> json,
) => A2AAPIKeySecurityScheme()
  ..description = json['description'] as String?
  ..location = json['location'] as String
  ..name = json['name'] as String?
  ..type = json['type'] as String;

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
  ..scheme = json['scheme'] as String
  ..type = json['type'] as String;

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
      : A2AOAuthFlows.fromJson(json['flows'] as Map<String, dynamic>)
  ..type = json['type'] as String;

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
  ..openIdConnectUrl = json['openIdConnectUrl'] as String
  ..type = json['type'] as String;

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
  ..isError = json['isError'] as bool
  ..error = json['error'] == null
      ? null
      : A2AError.fromJson(json['error'] as Map<String, dynamic>)
  ..id = json['id']
  ..jsonrpc = json['jsonrpc'] as String;

Map<String, dynamic> _$A2AJSONRPCErrorResponseToJson(
  A2AJSONRPCErrorResponse instance,
) => <String, dynamic>{
  'isError': instance.isError,
  'error': instance.error?.toJson(),
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
};

A2ACancelTaskSuccessResponse _$A2ACancelTaskSuccessResponseFromJson(
  Map<String, dynamic> json,
) => A2ACancelTaskSuccessResponse()
  ..isError = json['isError'] as bool
  ..id = json['id']
  ..jsonrpc = json['jsonrpc'] as String
  ..result = json['result'] == null
      ? null
      : A2ATask.fromJson(json['result'] as Map<String, dynamic>);

Map<String, dynamic> _$A2ACancelTaskSuccessResponseToJson(
  A2ACancelTaskSuccessResponse instance,
) => <String, dynamic>{
  'isError': instance.isError,
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
  'result': instance.result?.toJson(),
};

A2AJSONRPCErrorResponseGTPR _$A2AJSONRPCErrorResponseGTPRFromJson(
  Map<String, dynamic> json,
) => A2AJSONRPCErrorResponseGTPR()
  ..isError = json['isError'] as bool
  ..error = json['error'] == null
      ? null
      : A2AError.fromJson(json['error'] as Map<String, dynamic>)
  ..id = json['id']
  ..jsonrpc = json['jsonrpc'] as String;

Map<String, dynamic> _$A2AJSONRPCErrorResponseGTPRToJson(
  A2AJSONRPCErrorResponseGTPR instance,
) => <String, dynamic>{
  'isError': instance.isError,
  'error': instance.error?.toJson(),
  'id': instance.id,
  'jsonrpc': instance.jsonrpc,
};

A2AGetTaskPushNotificationConfigSuccessResponse
_$A2AGetTaskPushNotificationConfigSuccessResponseFromJson(
  Map<String, dynamic> json,
) => A2AGetTaskPushNotificationConfigSuccessResponse()
  ..isError = json['isError'] as bool
  ..id = json['id']
  ..result = json['result'] == null
      ? null
      : A2ATaskPushNotificationConfig1.fromJson(
          json['result'] as Map<String, dynamic>,
        );

Map<String, dynamic> _$A2AGetTaskPushNotificationConfigSuccessResponseToJson(
  A2AGetTaskPushNotificationConfigSuccessResponse instance,
) => <String, dynamic>{
  'isError': instance.isError,
  'id': instance.id,
  'result': instance.result?.toJson(),
};

A2AAgentCapabilities _$A2AAgentCapabilitiesFromJson(
  Map<String, dynamic> json,
) => A2AAgentCapabilities()
  ..extensions = (json['extensions'] as List<dynamic>)
      .map((e) => A2AAgentExtension.fromJson(e as Map<String, dynamic>))
      .toList()
  ..pushNotifications = json['pushNotifications'] as bool?
  ..stateTransitionHistory = json['stateTransitionHistory'] as bool?
  ..streaming = json['streaming'] as bool?;

Map<String, dynamic> _$A2AAgentCapabilitiesToJson(
  A2AAgentCapabilities instance,
) => <String, dynamic>{
  'extensions': instance.extensions.map((e) => e.toJson()).toList(),
  'pushNotifications': instance.pushNotifications,
  'stateTransitionHistory': instance.stateTransitionHistory,
  'streaming': instance.streaming,
};

A2AAgentExtension _$A2AAgentExtensionFromJson(Map<String, dynamic> json) =>
    A2AAgentExtension()
      ..description = json['description'] as String?
      ..params = (json['params'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as Object),
      )
      ..required = json['required'] as bool?
      ..uri = json['uri'] as String;

Map<String, dynamic> _$A2AAgentExtensionToJson(A2AAgentExtension instance) =>
    <String, dynamic>{
      'description': instance.description,
      'params': instance.params,
      'required': instance.required,
      'uri': instance.uri,
    };

A2AAgentCard _$A2AAgentCardFromJson(Map<String, dynamic> json) => A2AAgentCard()
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
  ..security = (json['security'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
  )
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
  ..version = json['version'] as String;

Map<String, dynamic> _$A2AAgentCardToJson(A2AAgentCard instance) =>
    <String, dynamic>{
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
