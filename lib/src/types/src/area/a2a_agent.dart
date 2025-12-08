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

/// Supported A2A transport protocols.
enum A2ATransportProtocol {
  /// he task has been submitted and is awaiting execution.
  @JsonValue('JSONRPC')
  jsonRpc,
  @JsonValue('GRPC')
  gRpc,
  @JsonValue('HTTP+JSON')
  httpJson,
}

/// Declares a combination of a target URL and a transport protocol for interacting with the agent.
/// This allows agents to expose the same functionality over multiple transport mechanisms.
@JsonSerializable(explicitToJson: true)
class A2AAgentInterface {
  /// The URL where this interface is available. Must be a valid absolute HTTPS URL in production.
  /// examples ["https://api.example.com/a2a/v1",
  /// "https://grpc.example.com/a2a", "https://rest.example.com/v1"]
  String url = '';

  /// The transport protocol supported at this URL.
  A2ATransportProtocol transport = A2ATransportProtocol.jsonRpc;

  A2AAgentInterface();

  factory A2AAgentInterface.fromJson(Map<String, dynamic> json) =>
      _$A2AAgentInterfaceFromJson(json);

  Map<String, dynamic> toJson() => _$A2AAgentInterfaceToJson(this);
}

/// AgentCardSignature represents a JWS signature of an AgentCard.
/// This follows the JSON format of an RFC 7515 JSON Web Signature (JWS).
@JsonSerializable(explicitToJson: true)
class A2AAgentCardSignature {
  /// The protected JWS header for the signature. This is a Base64url-encoded
  /// JSON object, as per RFC 7515.
  String protected = '';

  /// The computed signature, Base64url-encoded.
  String signature = '';

  /// The unprotected JWS header values.
  A2ASV? header;

  A2AAgentCardSignature();

  factory A2AAgentCardSignature.fromJson(Map<String, dynamic> json) =>
      _$A2AAgentCardSignatureFromJson(json);

  Map<String, dynamic> toJson() => _$A2AAgentCardSignatureToJson(this);
}

/// An AgentCard conveys key information:
/// - Overall details (version, name, description, uses)
/// - Skills: A set of capabilities the agent can perform
/// - Default modalities/content types supported by the agent.
/// - Authentication requirements.
@JsonSerializable(explicitToJson: true)
final class A2AAgentCard extends A2AAgent {
  /// The version of the A2A protocol this agent supports.
  String protocolVersion = '0.3.0';

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

  /// An optional URL to an icon for the agent.
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
  List<Map<String, List<String>>>? security;

  /// A declaration of the security schemes available to authorize requests. The key is the
  /// scheme name. Follows the OpenAPI 3.0 Security Scheme Object.
  Map<String, A2ASecurityScheme>? securitySchemes;

  /// The set of skills, or distinct capabilities, that the agent can perform.
  List<A2AAgentSkill> skills = [];

  /// True if the agent supports providing an extended agent card when the user is authenticated.
  /// Defaults to false if not specified.
  bool? supportsAuthenticatedExtendedCard;

  /// The preferred endpoint URL for interacting with the agent.
  /// This URL MUST support the transport specified by 'preferredTransport'.
  String url = '';

  /// IMPORTANT: The transport specified here MUST be available at the main 'url'.
  /// This creates a binding between the main URL and its supported transport protocol.
  /// Clients should prefer this transport and URL combination when both are supported.
  A2ATransportProtocol? preferredTransport = A2ATransportProtocol.jsonRpc;

  /// A list of additional supported interfaces (transport and URL combinations).
  /// This allows agents to expose multiple transports, potentially at different URLs.
  ///
  /// Best practices:
  ///   SHOULD include all supported transports for completeness
  ///   SHOULD include an entry matching the main 'url' and 'preferredTransport'
  ///   MAY reuse URLs if multiple transports are available at the same endpoint
  ///   MUST accurately declare the transport available at each URL
  ///
  /// Clients can select any interface from this list based on their transport capabilities
  /// and preferences. This enables transport negotiation and fallback scenarios.
  List<A2AAgentInterface>? additionalInterfaces;

  /// JSON Web Signatures computed for this AgentCard.
  List<A2AAgentCardSignature>? signatures;

  /// The agent's own version number. The format is defined by the provider.
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
