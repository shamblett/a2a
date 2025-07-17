// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'a2a_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
