/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// Agent class
class A2AAgent {}

/// Defines optional capabilities supported by an agent.
@JsonSerializable(explicitToJson: true)
final class A2AAgentCapabilities {
  /// Extensions supported by this agent.
  List<A2AAgentExtension>? extensions;

  /// True if the agent can notify updates to client.
  bool? pushNotifications;

  /// True if the agent exposes status change history for tasks.
  bool? stateTransitionHistory;

  /// True if the agent supports SSE.
  bool? streaming;

  A2AAgentCapabilities();

  factory A2AAgentCapabilities.fromJson(Map<String, dynamic> json) =>
      _$A2AAgentCapabilitiesFromJson(json);

  Map<String, dynamic> toJson() => _$A2AAgentCapabilitiesToJson(this);
}

/// A declaration of an extension supported by an Agent.
@JsonSerializable(explicitToJson: true)
final class A2AAgentExtension {
  /// A description of how this agent uses this extension.
  String? description;

  /// Optional configuration for the extension.
  A2ASV? params;

  /// Whether the client must follow specific requirements of the extension.
  bool? required;

  /// The URI of the extension.
  String uri = '';

  A2AAgentExtension();

  factory A2AAgentExtension.fromJson(Map<String, dynamic> json) =>
      _$A2AAgentExtensionFromJson(json);

  Map<String, dynamic> toJson() => _$A2AAgentExtensionToJson(this);
}

/// An AgentCard conveys key information:
/// - Overall details (version, name, description, uses)
/// - Skills: A set of capabilities the agent can perform
/// - Default modalities/content types supported by the agent.
/// - Authentication requirements.
@JsonSerializable(explicitToJson: true)
final class A2AAgentCard extends A2AAgent {
  /// A declaration of optional capabilities supported by the agent.
  A2AAgentCapabilities capabilities = A2AAgentCapabilities();

  /// Default set of supported input MIME types for all skills, which can be
  /// overridden on a per-skill basis.
  List<String> defaultInputModes = [];

  /// Default set of supported output MIME types for all skills, which can be
  /// overridden on a per-skill basis.
  List<String> defaultOutputModes = [];

  /// A human-readable description of the agent. Used to assist users and
  /// other agents in understanding what the agent can do.
  String description = '';

  /// A URL to documentation for the agent.
  String? documentationUrl;

  /// A URL to an icon for the agent.
  String? iconUrl;

  /// Human readable name of the agent.
  String name = '';

  /// Information about the agent's service provider.
  A2AAgentProvider? agentProvider;

  /// A list of security requirement objects that apply to all agent interactions. Each object
  /// lists security schemes that can be used. Follows the OpenAPI 3.0 Security Requirement Object.
  /// This list can be seen as an OR of ANDs. Each object in the list describes one possible
  /// set of security requirements that must be present on a request. This allows specifying,
  /// for example, "callers must either use OAuth OR an API Key AND mTLS."
  Map<String, List<String>>? security;

  /// A declaration of the security schemes available to authorize requests. The key is the
  /// scheme name. Follows the OpenAPI 3.0 Security Scheme Object.
  Map<String, A2ASecurityScheme>? securitySchemes;

  /// The set of skills, or distinct capabilities, that the agent can perform.
  List<A2AAgentSkill> skills = [];

  /// True if the agent supports providing an extended agent card when the user is authenticated.
  /// Defaults to false if not specified.
  bool? supportsAuthenticatedExtendedCard;

  /// A URL to the address the agent is hosted at.
  String url = '';

  /// The version of the agent - format is up to the provider.
  String version = '';

  A2AAgentCard();

  factory A2AAgentCard.fromJson(Map<String, dynamic> json) =>
      _$A2AAgentCardFromJson(json);

  Map<String, dynamic> toJson() => _$A2AAgentCardToJson(this);
}

/// The service provider of the agent
@JsonSerializable(explicitToJson: true)
final class A2AAgentProvider extends A2AAgent {
  /// Agent provider's organization name.
  String organization = '';

  /// Agent provider's URL.
  String url = '';

  A2AAgentProvider();

  factory A2AAgentProvider.fromJson(Map<String, dynamic> json) =>
      _$A2AAgentProviderFromJson(json);

  Map<String, dynamic> toJson() => _$A2AAgentProviderToJson(this);
}

/// Represents a unit of capability that an agent can perform.
@JsonSerializable(explicitToJson: true)
final class A2AAgentSkill extends A2AAgent {
  /// Description of the skill - will be used by the client or a human
  /// as a hint to understand what the skill does.
  String description = '';

  /// The set of example scenarios that the skill can perform.
  /// Will be used by the client as a hint to understand how the skill can be used.
  List<String> examples = [];

  /// Unique identifier for the agent's skill.
  String id = '';

  /// The set of supported input MIME types for this skill, overriding the agent's defaults.
  List<String>? inputModes;

  /// Human readable name of the skill.
  String name = '';

  /// he set of supported output MIME types for this skill, overriding the agent's defaults.
  List<String>? outputModes;

  /// Set of tag words describing classes of capabilities for this specific skill.
  List<String>? tags;

  A2AAgentSkill();

  factory A2AAgentSkill.fromJson(Map<String, dynamic> json) =>
      _$A2AAgentSkillFromJson(json);

  Map<String, dynamic> toJson() => _$A2AAgentSkillToJson(this);
}
