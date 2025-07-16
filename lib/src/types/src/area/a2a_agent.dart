/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_types.dart';

/// Agent class
sealed class A2AAgent {}

/// Defines optional capabilities supported by an agent.
@JsonSerializable(explicitToJson: true)
final class A2AAgentCapabilities {
  /// Extensions supported by this agent.
  List<A2AAgentExtension> extensions = [];

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
  A2AAgentCapabilities? capabilities;

  /// The set of interaction modes that the agent supports across all skills. This can be overridden per-skill.
  /// Supported media types for input.
  List<String> defaultInputModes = [];

  /// Supported media types for output.
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
  A2AAgentProvider? agentProvider;

  /// Security requirements for contacting the agent.
  Map<String, List<String>> security = {};

  /// Security requirements for contacting the agent.
  Map<String, A2ASecurityScheme>? securitySchemes;

  /// Skills are a unit of capability that an agent can perform.
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

  /// The set of interaction modes that the skill supports
  /// (if different than the default).
  /// Supported media types for input.
  List<String>? inputModes;

  /// Human readable name of the skill.
  String name = '';

  /// Supported media types for output.
  List<String>? outputModes;

  /// Set of tag words describing classes of capabilities for this specific skill.
  List<String>? tags;

  A2AAgentSkill();

  factory A2AAgentSkill.fromJson(Map<String, dynamic> json) =>
      _$A2AAgentSkillFromJson(json);

  Map<String, dynamic> toJson() => _$A2AAgentSkillToJson(this);
}
