/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// Mirrors the OpenAPI Security Scheme Object
/// (https://swagger.io/specification/#security-scheme-object)
base class A2ASecurityScheme {}

final class APIKeySecurityScheme extends A2ASecurityScheme {}

final class HTTPAuthSecurityScheme extends A2ASecurityScheme {}

final class OAuth2SecurityScheme extends A2ASecurityScheme {}

final class OpenIdConnectSecurityScheme extends A2ASecurityScheme {}
