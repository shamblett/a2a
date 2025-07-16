// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'a2a_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

A2ASecurityScheme _$A2ASecuritySchemeFromJson(Map<String, dynamic> json) =>
    A2ASecurityScheme();

Map<String, dynamic> _$A2ASecuritySchemeToJson(A2ASecurityScheme instance) =>
    <String, dynamic>{};

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
  ..capabilities = json['capabilities'] == null
      ? null
      : A2AAgentCapabilities.fromJson(
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
      'capabilities': instance.capabilities?.toJson(),
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
