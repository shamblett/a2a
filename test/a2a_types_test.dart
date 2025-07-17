/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

@TestOn('vm')
library;

import 'package:test/test.dart';

import 'package:a2a/a2a.dart';

void main() {
  group('Security Schemes', () {
    test('A2AAPIKeySecurityScheme', () {
      var securityScheme = A2ASecurityScheme();
      var json = <String, dynamic>{};

      var testScheme = A2AAPIKeySecurityScheme()
        ..description = 'The Description'
        ..name = 'The Name'
        ..location = 'query';
      securityScheme = testScheme;
      json = securityScheme.toJson();
      securityScheme = A2ASecurityScheme();
      securityScheme = A2ASecurityScheme.fromJson(json);
      expect(securityScheme is A2AAPIKeySecurityScheme, isTrue);
      final testScheme1 = securityScheme as A2AAPIKeySecurityScheme;
      expect(testScheme1.name, 'The Name');
      expect(testScheme1.description, 'The Description');
      expect(testScheme1.location, 'query');
      expect(testScheme1.type, 'apiKey');
    });
    test('A2AHTTPAuthSecurityScheme', () {
      var securityScheme = A2ASecurityScheme();
      var json = <String, dynamic>{};

      var testScheme = A2AHTTPAuthSecurityScheme()
        ..description = 'The Description'
        ..scheme = 'scheme';
      securityScheme = testScheme;
      json = securityScheme.toJson();
      securityScheme = A2ASecurityScheme();
      securityScheme = A2ASecurityScheme.fromJson(json);
      expect(securityScheme is A2AHTTPAuthSecurityScheme, isTrue);
      final testScheme1 = securityScheme as A2AHTTPAuthSecurityScheme;
      expect(testScheme1.headerFormat, isNull);
      expect(testScheme1.description, 'The Description');
      expect(testScheme1.type, 'http');
    });
    test('A2AOAuth2SecurityScheme', () {
      var securityScheme = A2ASecurityScheme();
      var json = <String, dynamic>{};

      var testScheme = A2AOAuth2SecurityScheme()
        ..description = 'The Description';
      securityScheme = testScheme;
      json = securityScheme.toJson();
      securityScheme = A2ASecurityScheme();
      securityScheme = A2ASecurityScheme.fromJson(json);
      expect(securityScheme is A2AOAuth2SecurityScheme, isTrue);
      final testScheme1 = securityScheme as A2AOAuth2SecurityScheme;
      expect(testScheme1.flows, isNull);
      expect(testScheme1.description, 'The Description');
      expect(testScheme1.type, 'oauth2');
    });
    test('A2AOpenIdConnectSecurityScheme', () {
      var securityScheme = A2ASecurityScheme();
      var json = <String, dynamic>{};

      var testScheme = A2AOpenIdConnectSecurityScheme()
        ..description = 'The Description'
        ..openIdConnectUrl = 'Connect URL';
      securityScheme = testScheme;
      json = securityScheme.toJson();
      securityScheme = A2ASecurityScheme();
      securityScheme = A2ASecurityScheme.fromJson(json);
      expect(securityScheme is A2AOpenIdConnectSecurityScheme, isTrue);
      final testScheme1 = securityScheme as A2AOpenIdConnectSecurityScheme;
      expect(testScheme1.openIdConnectUrl, 'Connect URL');
      expect(testScheme1.description, 'The Description');
      expect(testScheme1.type, 'openIdConnect');
    });
  });
}
