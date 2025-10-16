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
  group('Agent', () {
    test('A2AAgent', () {
      A2AAgent();
      final cap = A2AAgentCapabilities();
      var json = cap.toJson();
      A2AAgentCapabilities.fromJson(json);
      final pro = A2AAgentProvider();
      json = pro.toJson();
      A2AAgentProvider.fromJson(json);
      final skill = A2AAgentSkill();
      json = skill.toJson();
      A2AAgentSkill.fromJson(json);
      final card = A2AAgentCard();
      json = card.toJson();
      A2AAgentCard.fromJson(json);
    });
    test('A2AAgentCapabilities', () {
      final cap = A2AAgentCapabilities();
      final ext = A2AAgentExtension()
        ..description = 'Ext description'
        ..params = {'First': 1}
        ..required = true
        ..uri = 'Ext URI';
      cap.extensions = [ext];
      cap.pushNotifications = true;
      cap.stateTransitionHistory = true;
      cap.streaming = true;
      final json = cap.toJson();
      final newCap = A2AAgentCapabilities.fromJson(json);
      expect(newCap.streaming, isTrue);
      expect(newCap.stateTransitionHistory, isTrue);
      expect(newCap.pushNotifications, isTrue);
      expect(newCap.extensions?.length, 1);
      final newExt = newCap.extensions?[0];
      expect(newExt?.uri, 'Ext URI');
      expect(newExt?.required, isTrue);
      expect(newExt?.params, {'First': 1});
      expect(newExt?.description, 'Ext description');
    });
    test('A2AAgentCard', () {
      final cap = A2AAgentCapabilities();
      final ext = A2AAgentExtension()
        ..description = 'Ext description'
        ..params = {'First': 1}
        ..required = true
        ..uri = 'Ext URI';
      cap.extensions = [ext];
      cap.pushNotifications = true;
      cap.stateTransitionHistory = true;
      cap.streaming = true;
      final card = A2AAgentCard();
      card.description = 'Card description';
      card.capabilities = cap;
      card.defaultInputModes = ['text'];
      card.defaultOutputModes = ['text'];
      card.documentationUrl = 'Card doc url';
      card.iconUrl = 'Card icon url';
      card.name = 'Card name';
      card.security = [
        {
          'security': ['1', '2'],
        },
      ];
      card.securitySchemes = {'First': A2ASecurityScheme()};
      card.skills = [A2AAgentSkill()];
      card.supportsAuthenticatedExtendedCard = true;
      card.url = 'Card.uri';
      card.version = '1.0.0';
      card.agentProvider = A2AAgentProvider();
      final json = card.toJson();
      final newCard = A2AAgentCard.fromJson(json);
      expect(newCard.version, '1.0.0');
      expect(newCard.url, 'Card.uri');
      expect(newCard.supportsAuthenticatedExtendedCard, isTrue);
      expect(newCard.skills.length, 1);
      expect(newCard.securitySchemes?.length, 1);
      expect(newCard.security?.length, 1);
      expect(newCard.agentProvider, isNotNull);
      expect(newCard.name, 'Card name');
      expect(newCard.iconUrl, 'Card icon url');
      expect(newCard.documentationUrl, 'Card doc url');
      expect(newCard.defaultOutputModes, ['text']);
      expect(newCard.defaultInputModes, ['text']);
      expect(newCard.description, 'Card description');
    });
    test('A2AAgentProvider', () {
      final pro = A2AAgentProvider()
        ..url = 'The url'
        ..organization = 'The organization';
      final json = pro.toJson();
      final newPro = A2AAgentProvider.fromJson(json);
      expect(newPro.organization, 'The organization');
      expect(newPro.url, 'The url');
    });
    test('A2AAgentSkill', () {
      final skill = A2AAgentSkill()
        ..description = 'The description'
        ..name = 'The name'
        ..id = 'The id'
        ..examples = ['1', '2']
        ..inputModes = ['text']
        ..outputModes = ['text']
        ..tags = ['tag'];
      final json = skill.toJson();
      final newSkill = A2AAgentSkill.fromJson(json);
      expect(newSkill.tags, ['tag']);
      expect(newSkill.outputModes, ['text']);
      expect(newSkill.inputModes, ['text']);
      expect(newSkill.examples, ['1', '2']);
      expect(newSkill.id, 'The id');
      expect(newSkill.name, 'The name');
      expect(newSkill.description, 'The description');
    });
  });

  group('Security Schemes', () {
    test('A2AAPIKeySecurityScheme', () {
      var securityScheme = A2ASecurityScheme();
      expect(securityScheme.toJson(), {});
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
        ..description = 'The Description'
        ..flows = (A2AOAuthFlows()
          ..authorizationCode = A2AAuthorizationCodeOAuthFlow()
          ..clientCredentials = A2AClientCredentialsOAuthFlow()
          ..implicit = A2AImplicitOAuthFlow()
          ..password = A2APasswordOAuthFlow());
      securityScheme = testScheme;
      json = securityScheme.toJson();
      securityScheme = A2ASecurityScheme();
      securityScheme = A2ASecurityScheme.fromJson(json);
      expect(securityScheme is A2AOAuth2SecurityScheme, isTrue);
      final testScheme1 = securityScheme as A2AOAuth2SecurityScheme;
      expect(testScheme1.flows, isNotNull);
      expect(testScheme1.flows?.password, isNotNull);
      expect(testScheme1.flows?.implicit, isNotNull);
      expect(testScheme1.flows?.clientCredentials, isNotNull);
      expect(testScheme1.flows?..authorizationCode, isNotNull);
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
  group('Cancel Task Response', () {
    test('A2AJSONRPCErrorResponse', () {
      var cancelTaskResponse = A2ACancelTaskResponse();
      expect(cancelTaskResponse.toJson(), {});
      var json = <String, dynamic>{};

      var testResponse = A2AJSONRPCErrorResponse()
        ..error = A2AError()
        ..id = 1;
      cancelTaskResponse = testResponse;
      json = cancelTaskResponse.toJson();
      cancelTaskResponse = A2ACancelTaskResponse();
      cancelTaskResponse = A2ACancelTaskResponse.fromJson(json);
      expect(cancelTaskResponse.isError, true);
      expect(cancelTaskResponse is A2AJSONRPCErrorResponse, isTrue);
      final testResponse1 = cancelTaskResponse as A2AJSONRPCErrorResponse;
      expect(testResponse1.error is A2AError, isTrue);
      expect(testResponse1.id, 1);
    });
    test('A2ACancelTaskSuccessResponse', () {
      var cancelTaskResponse = A2ACancelTaskResponse();
      var json = <String, dynamic>{};

      var testResponse = A2ACancelTaskSuccessResponse()
        ..result = A2ATask()
        ..id = 2;
      cancelTaskResponse = testResponse;
      json = cancelTaskResponse.toJson();
      cancelTaskResponse = A2ACancelTaskResponse();
      cancelTaskResponse = A2ACancelTaskResponse.fromJson(json);
      expect(cancelTaskResponse is A2ACancelTaskSuccessResponse, isTrue);
      final testResponse1 = cancelTaskResponse as A2ACancelTaskSuccessResponse;
      expect(testResponse1.result is A2ATask, isTrue);
      expect(testResponse1.id, 2);
    });
  });
  group('Error', () {
    test('A2AJSONRPCError - supported error', () {
      var error = A2AError();
      var json = <String, dynamic>{};

      var testError = A2AJSONRPCError()
        ..message = 'The message'
        ..data = {'First': 1};
      error = testError;
      json = error.toJson();
      error = A2AError();
      error = A2AError.fromJson(json);
      expect(error is A2AJSONRPCError, isTrue);
      final testError1 = error as A2AJSONRPCError;
      expect(testError1.data, {'First': 1});
      expect(testError1.message, 'The message');
      expect(testError1.code, A2AError.jsonRpc);
    });
    test('A2AJSONRPCError - unsupported error', () {
      var error = A2AError();
      var json = <String, dynamic>{};

      var testError = A2AJSONRPCError()
        ..message = 'The message'
        ..data = {'First': 1}
        ..code = 500;
      error = testError;
      json = error.toJson();
      final newError = A2AError.fromJson(json);
      expect(newError.rpcErrorCode, 500);
    });
    test('A2AJSONParseError', () {
      var error = A2AError();
      var json = <String, dynamic>{};

      var testError = A2AJSONParseError()
        ..message = 'The message'
        ..data = {'First': 1};
      error = testError;
      json = error.toJson();
      error = A2AError();
      error = A2AError.fromJson(json);
      expect(error is A2AJSONParseError, isTrue);
      final testError1 = error as A2AJSONParseError;
      expect(testError1.data, {'First': 1});
      expect(testError1.message, 'The message');
      expect(testError1.code, A2AError.jsonParse);
    });
    test('A2AInvalidRequestError', () {
      var error = A2AError();
      var json = <String, dynamic>{};

      var testError = A2AInvalidRequestError()
        ..message = 'The message'
        ..data = {'First': 1};
      error = testError;
      json = error.toJson();
      error = A2AError();
      error = A2AError.fromJson(json);
      expect(error is A2AInvalidRequestError, isTrue);
      final testError1 = error as A2AInvalidRequestError;
      expect(testError1.data, {'First': 1});
      expect(testError1.message, 'The message');
      expect(testError1.code, A2AError.invalidRequest);
    });
    test('A2AMethodNotFoundError', () {
      var error = A2AError();
      var json = <String, dynamic>{};

      var testError = A2AMethodNotFoundError()
        ..message = 'The message'
        ..data = {'First': 1};
      error = testError;
      json = error.toJson();
      error = A2AError();
      error = A2AError.fromJson(json);
      expect(error is A2AMethodNotFoundError, isTrue);
      final testError1 = error as A2AMethodNotFoundError;
      expect(testError1.data, {'First': 1});
      expect(testError1.message, 'The message');
      expect(testError1.code, A2AError.methodNotFound);
    });
    test('A2AInvalidParamsError', () {
      var error = A2AError();
      var json = <String, dynamic>{};

      var testError = A2AInvalidParamsError()
        ..message = 'The message'
        ..data = {'First': 1};
      error = testError;
      json = error.toJson();
      error = A2AError();
      error = A2AError.fromJson(json);
      expect(error is A2AInvalidParamsError, isTrue);
      final testError1 = error as A2AInvalidParamsError;
      expect(testError1.data, {'First': 1});
      expect(testError1.message, 'The message');
      expect(testError1.code, A2AError.invalidParams);
    });
    test('A2AInternalError', () {
      var error = A2AError();
      var json = <String, dynamic>{};

      var testError = A2AInternalError()
        ..message = 'The message'
        ..data = {'First': 1};
      error = testError;
      json = error.toJson();
      error = A2AError();
      error = A2AError.fromJson(json);
      expect(error is A2AInternalError, isTrue);
      final testError1 = error as A2AInternalError;
      expect(testError1.data, {'First': 1});
      expect(testError1.message, 'The message');
      expect(testError1.code, A2AError.internal);
    });
    test('A2ATaskNotFoundError', () {
      var error = A2AError();
      var json = <String, dynamic>{};

      var testError = A2ATaskNotFoundError()
        ..message = 'The message'
        ..data = {'First': 1};
      error = testError;
      json = error.toJson();
      error = A2AError();
      error = A2AError.fromJson(json);
      expect(error is A2ATaskNotFoundError, isTrue);
      final testError1 = error as A2ATaskNotFoundError;
      expect(testError1.data, {'First': 1});
      expect(testError1.message, 'The message');
      expect(testError1.code, A2AError.taskNotFound);
    });
    test('A2ATaskNotCancelableError', () {
      var error = A2AError();
      var json = <String, dynamic>{};

      var testError = A2ATaskNotCancelableError()
        ..message = 'The message'
        ..data = {'First': 1};
      error = testError;
      json = error.toJson();
      error = A2AError();
      error = A2AError.fromJson(json);
      expect(error is A2ATaskNotCancelableError, isTrue);
      final testError1 = error as A2ATaskNotCancelableError;
      expect(testError1.data, {'First': 1});
      expect(testError1.message, 'The message');
      expect(testError1.code, A2AError.taskNotCancellable);
    });
    test('A2APushNotificationNotSupportedError', () {
      var error = A2AError();
      var json = <String, dynamic>{};

      var testError = A2APushNotificationNotSupportedError()
        ..message = 'The message'
        ..data = {'First': 1};
      error = testError;
      json = error.toJson();
      error = A2AError();
      error = A2AError.fromJson(json);
      expect(error is A2APushNotificationNotSupportedError, isTrue);
      final testError1 = error as A2APushNotificationNotSupportedError;
      expect(testError1.data, {'First': 1});
      expect(testError1.message, 'The message');
      expect(testError1.code, A2AError.pushNotificationNotSupported);
    });
    test('A2AUnsupportedOperationError', () {
      var error = A2AError();
      var json = <String, dynamic>{};

      var testError = A2AUnsupportedOperationError()
        ..message = 'The message'
        ..data = {'First': 1};
      error = testError;
      json = error.toJson();
      error = A2AError();
      error = A2AError.fromJson(json);
      expect(error is A2AUnsupportedOperationError, isTrue);
      final testError1 = error as A2AUnsupportedOperationError;
      expect(testError1.data, {'First': 1});
      expect(testError1.message, 'The message');
      expect(testError1.code, A2AError.unsupportedOperation);
    });
    test('A2AContentTypeNotSupportedError', () {
      var error = A2AError();
      var json = <String, dynamic>{};

      var testError = A2AContentTypeNotSupportedError()
        ..message = 'The message'
        ..data = {'First': 1};
      error = testError;
      json = error.toJson();
      error = A2AError();
      error = A2AError.fromJson(json);
      expect(error is A2AContentTypeNotSupportedError, isTrue);
      final testError1 = error as A2AContentTypeNotSupportedError;
      expect(testError1.data, {'First': 1});
      expect(testError1.message, 'The message');
      expect(testError1.code, A2AError.contentTypeNotSupported);
    });
    test('A2AInvalidAgentResponseError', () {
      var error = A2AError();
      var json = <String, dynamic>{};

      var testError = A2AInvalidAgentResponseError()
        ..message = 'The message'
        ..data = {'First': 1};
      error = testError;
      json = error.toJson();
      error = A2AError();
      error = A2AError.fromJson(json);
      expect(error is A2AInvalidAgentResponseError, isTrue);
      final testError1 = error as A2AInvalidAgentResponseError;
      expect(testError1.data, {'First': 1});
      expect(testError1.message, 'The message');
      expect(testError1.code, A2AError.invalidAgentResponse);
    });
  });
  group('Push Notification Config Response', () {
    test('A2AJSONRPCErrorResponseGTPR', () {
      var pncTaskResponse = A2AGetTaskPushNotificationConfigResponse();
      expect(pncTaskResponse.toJson(), {});
      var json = <String, dynamic>{};

      var testResponse = A2AJSONRPCErrorResponseGTPR()
        ..error = A2AError()
        ..id = 1;
      pncTaskResponse = testResponse;
      json = pncTaskResponse.toJson();
      pncTaskResponse = A2AGetTaskPushNotificationConfigResponse();
      pncTaskResponse = A2AGetTaskPushNotificationConfigResponse.fromJson(json);
      expect(pncTaskResponse.isError, true);
      expect(pncTaskResponse is A2AJSONRPCErrorResponseGTPR, isTrue);
      final testResponse1 = pncTaskResponse as A2AJSONRPCErrorResponseGTPR;
      expect(testResponse1.error is A2AError, isTrue);
      expect(testResponse1.id, 1);
    });
    test('A2AGetTaskPushNotificationConfigSuccessResponse', () {
      var pncTaskResponse = A2AGetTaskPushNotificationConfigResponse();
      var json = <String, dynamic>{};

      var testResponse = A2AGetTaskPushNotificationConfigSuccessResponse()
        ..result = A2ATaskPushNotificationConfig()
        ..id = 2;
      pncTaskResponse = testResponse;
      json = pncTaskResponse.toJson();
      pncTaskResponse = A2AGetTaskPushNotificationConfigResponse();
      pncTaskResponse = A2AGetTaskPushNotificationConfigResponse.fromJson(json);
      expect(
        pncTaskResponse is A2AGetTaskPushNotificationConfigSuccessResponse,
        isTrue,
      );
      final testResponse1 =
          pncTaskResponse as A2AGetTaskPushNotificationConfigSuccessResponse;
      expect(testResponse1.result is A2ATaskPushNotificationConfig, isTrue);
      expect(testResponse1.id, 2);
    });
  });
  group('Task Response', () {
    test('A2AJSONRPCErrorResponseT', () {
      var taskResponse = A2AGetTaskResponse();
      expect(taskResponse.toJson(), {});
      var json = <String, dynamic>{};

      var testResponse = A2AJSONRPCErrorResponseT()
        ..error = A2AError()
        ..id = 1;
      taskResponse = testResponse;
      json = taskResponse.toJson();

      taskResponse = A2AGetTaskResponse();
      taskResponse = A2AGetTaskResponse.fromJson(json);
      expect(taskResponse.isError, true);
      expect(taskResponse is A2AJSONRPCErrorResponseT, isTrue);
      final testResponse1 = taskResponse as A2AJSONRPCErrorResponseT;
      expect(testResponse1.error is A2AError, isTrue);
      expect(testResponse1.id, 1);
    });
    test('A2AGetTaskSuccessResponse', () {
      var taskResponse = A2AGetTaskResponse();
      var json = <String, dynamic>{};

      var testResponse = A2AGetTaskSuccessResponse()
        ..result = A2ATask()
        ..id = 2;
      taskResponse = testResponse;
      json = taskResponse.toJson();
      taskResponse = A2AGetTaskResponse();
      taskResponse = A2AGetTaskResponse.fromJson(json);
      expect(taskResponse is A2AGetTaskSuccessResponse, isTrue);
      final testResponse1 = taskResponse as A2AGetTaskSuccessResponse;
      expect(testResponse1.result is A2ATask, isTrue);
      expect(testResponse1.id, 2);
    });
  });
  group('JSON RPC Response', () {
    test('Send Message Response - Success', () {
      var messageResponse = A2ASendMessageResponse();
      expect(messageResponse.toJson(), {});
      var json = <String, dynamic>{};

      var testResponse = A2ASendMessageSuccessResponse()
        ..id = 1
        ..result = A2ATask();
      messageResponse = testResponse;
      json = messageResponse.toJson();

      messageResponse = A2ASendMessageResponse();
      messageResponse = A2ASendMessageResponse.fromJson(json);
      expect(messageResponse.isError, isFalse);
      expect(messageResponse is A2ASendMessageSuccessResponse, isTrue);
      final testResponse1 = messageResponse as A2ASendMessageSuccessResponse;
      expect(testResponse1.result is A2ATask, isTrue);
      expect(testResponse1.id, 1);
    });
    test('Send Message Response - Error', () {
      var messageResponse = A2ASendMessageResponse();
      expect(messageResponse.toJson(), {});
      var json = <String, dynamic>{};

      var testResponse = A2AJSONRPCErrorResponseS()
        ..id = 1
        ..error = A2AError();
      messageResponse = testResponse;
      json = messageResponse.toJson();

      messageResponse = A2ASendMessageResponse();
      messageResponse = A2ASendMessageResponse.fromJson(json);
      expect(messageResponse.isError, true);
      expect(messageResponse is A2AJSONRPCErrorResponseS, isTrue);
      final testResponse1 = messageResponse as A2AJSONRPCErrorResponseS;
      expect(testResponse1.error is A2AError, isTrue);
      expect(testResponse1.id, 1);
    });
    test('Send Message Response - Error JSON', () {
      var messageResponse = A2AJsonRpcResponse();
      expect(messageResponse.toJson(), {});
      var json = <String, dynamic>{};

      var testResponse = A2AJSONRPCErrorResponseS()
        ..error = A2AError()
        ..id = 1;
      messageResponse = testResponse;
      json = messageResponse.toJson();

      messageResponse = A2AJsonRpcResponse();
      messageResponse = A2AJsonRpcResponse.fromJson(json);
      expect(messageResponse.isError, true);
      expect(messageResponse is A2AJSONRPCErrorResponseS, isTrue);
      final testResponse1 = messageResponse as A2AJSONRPCErrorResponseS;
      expect(testResponse1.error is A2AError, isTrue);
      expect(testResponse1.id, 1);
    });
    test('Send Message Response - Success - Task', () {
      var messageResponse = A2AJsonRpcResponse();
      var json = <String, dynamic>{};

      final task = A2ATask()
        ..id = '3'
        ..status = A2ATaskStatus()
        ..contextId = 'Context id';
      var testResponse = A2ASendMessageSuccessResponse()
        ..id = 2
        ..result = task;
      messageResponse = testResponse as A2ASendMessageResponse;
      json = messageResponse.toJson();
      messageResponse = A2AJsonRpcResponse();
      messageResponse = A2AJsonRpcResponse.fromJson(json);
      expect(messageResponse is A2ASendMessageSuccessResponse, isTrue);
      final testResponse1 = messageResponse as A2ASendMessageSuccessResponse;
      expect(testResponse1.result is A2ATask, isTrue);
      final taskResponse = testResponse1.result as A2ATask;
      expect(taskResponse.contextId, 'Context id');
      expect(taskResponse.id, '3');
      expect(taskResponse.status is A2ATaskStatus, isTrue);
      expect(testResponse1.id, 2);
    });
    test('Send Message Response - Success - Message', () {
      var messageResponse = A2AJsonRpcResponse();
      var json = <String, dynamic>{};

      final message = A2AMessage()
        ..taskId = '1'
        ..contextId = 'Context id';
      var testResponse = A2ASendMessageSuccessResponse()
        ..id = 2
        ..result = message;

      messageResponse = testResponse as A2ASendMessageResponse;
      json = messageResponse.toJson();
      messageResponse = A2AJsonRpcResponse();
      messageResponse = A2AJsonRpcResponse.fromJson(json);
      expect(messageResponse is A2ASendMessageSuccessResponse, isTrue);
      final testResponse1 = messageResponse as A2ASendMessageSuccessResponse;
      expect(testResponse1.result is A2AMessage, isTrue);
      final taskResponse = testResponse1.result as A2AMessage;
      expect(taskResponse.contextId, 'Context id');
      expect(taskResponse.taskId, '1');
      expect(testResponse1.id, 2);
    });
    test('Send Streaming Message Response - Success', () {
      var messageResponse = A2ASendStreamingMessageResponse();
      expect(messageResponse.toJson(), {});
      var json = <String, dynamic>{};

      var testResponse = A2ASendStreamingMessageSuccessResponse()
        ..id = 1
        ..result = A2ATask();
      messageResponse = testResponse;
      json = messageResponse.toJson();

      messageResponse = A2ASendStreamingMessageResponse();
      messageResponse = A2ASendStreamingMessageResponse.fromJson(json);
      expect(messageResponse.isError, isFalse);
      expect(messageResponse is A2ASendStreamingMessageSuccessResponse, isTrue);
      final testResponse1 =
          messageResponse as A2ASendStreamingMessageSuccessResponse;
      expect(testResponse1.result is A2ATask, isTrue);
      expect(testResponse1.id, 1);
    });
    test('Send Streaming Message Response - Error', () {
      var messageResponse = A2ASendStreamingMessageResponse();
      expect(messageResponse.toJson(), {});
      var json = <String, dynamic>{};

      var testResponse = A2AJSONRPCErrorResponseSS()
        ..id = 1
        ..error = A2AError();
      messageResponse = testResponse;
      json = messageResponse.toJson();

      messageResponse = A2ASendStreamingMessageResponse();
      messageResponse = A2ASendStreamingMessageResponse.fromJson(json);
      expect(messageResponse.isError, true);
      expect(messageResponse is A2AJSONRPCErrorResponseSS, isTrue);
      final testResponse1 = messageResponse as A2AJSONRPCErrorResponseSS;
      expect(testResponse1.error is A2AError, isTrue);
      expect(testResponse1.id, 1);
    });
    test('Send Streaming Message Response - Error JSON', () {
      var messageResponse = A2AJsonRpcResponse();
      var json = <String, dynamic>{};

      var testResponse = A2AJSONRPCErrorResponseSS()
        ..error = A2AError()
        ..id = 1;
      messageResponse = testResponse;
      json = messageResponse.toJson();

      messageResponse = A2AJsonRpcResponse();
      messageResponse = A2AJsonRpcResponse.fromJson(json);
      expect(messageResponse.isError, true);
      expect(messageResponse is A2AJSONRPCErrorResponseS, isTrue);
      final testResponse1 = messageResponse as A2AJSONRPCErrorResponseS;
      expect(testResponse1.error is A2AError, isTrue);
      expect(testResponse1.id, 1);
    });
    test('Send Streaming Message Response - Success - Task', () {
      var messageResponse = A2AJsonRpcResponse();
      var json = <String, dynamic>{};

      final updateEvent = A2ATaskStatusUpdateEvent()
        ..taskId = '4'
        ..contextId = 'Context id'
        ..end = true;
      var testResponse = A2ASendStreamingMessageSuccessResponse()
        ..id = 2
        ..result = updateEvent;

      messageResponse = testResponse;
      json = messageResponse.toJson();
      messageResponse = A2AJsonRpcResponse();
      messageResponse = A2AJsonRpcResponse.fromJson(json);
      expect(messageResponse is A2ASendStreamingMessageSuccessResponse, isTrue);
      final testResponse1 =
          messageResponse as A2ASendStreamingMessageSuccessResponse;
      expect(testResponse1.result is A2ATaskStatusUpdateEvent, isTrue);
      final taskResponse = testResponse1.result as A2ATaskStatusUpdateEvent;
      expect(taskResponse.contextId, 'Context id');
      expect(taskResponse.taskId, '4');
      expect(taskResponse.end, isTrue);
      expect(testResponse1.id, 2);
    });
    test('Send Streaming Message Response - Success - Message', () {
      var messageResponse = A2AJsonRpcResponse();
      var json = <String, dynamic>{};

      final updateEvent = A2AMessage()
        ..metadata = {'First': 1}
        ..taskId = '1'
        ..messageId = '100'
        ..contextId = '200'
        ..extensions = ['text'];

      var testResponse = A2ASendStreamingMessageSuccessResponse()
        ..id = 2
        ..result = updateEvent;

      messageResponse = testResponse;
      json = messageResponse.toJson();
      messageResponse = A2AJsonRpcResponse();
      messageResponse = A2AJsonRpcResponse.fromJson(json);
      expect(messageResponse is A2ASendMessageSuccessResponse, isTrue);
      final testResponse1 = messageResponse as A2ASendMessageSuccessResponse;
      expect(testResponse1.result is A2AMessage, isTrue);
      final taskResponse = testResponse1.result as A2AMessage;
      expect(taskResponse.contextId, '200');
      expect(taskResponse.taskId, '1');
      expect(taskResponse.messageId, '100');
      expect(taskResponse.metadata, {'First': 1});
      expect(taskResponse.extensions, ['text']);
      expect(testResponse1.id, 2);
    });
    test('Send Streaming Message Response - Success - Artifact Update', () {
      var messageResponse = A2AJsonRpcResponse();
      var json = <String, dynamic>{};

      final updateEvent = A2ATaskArtifactUpdateEvent()
        ..taskId = '100'
        ..metadata = {'First': 1}
        ..append = true
        ..artifact = A2AArtifact();

      var testResponse = A2ASendStreamingMessageSuccessResponse()
        ..id = 2
        ..result = updateEvent;

      messageResponse = testResponse;
      json = messageResponse.toJson();
      messageResponse = A2AJsonRpcResponse();
      messageResponse = A2AJsonRpcResponse.fromJson(json);
      expect(messageResponse is A2ASendStreamingMessageSuccessResponse, isTrue);
      final testResponse1 =
          messageResponse as A2ASendStreamingMessageSuccessResponse;
      expect(testResponse1.result is A2ATaskArtifactUpdateEvent, isTrue);
      final taskResponse = testResponse1.result as A2ATaskArtifactUpdateEvent;

      expect(taskResponse.taskId, '100');
      expect(taskResponse.metadata, {'First': 1});
      expect(taskResponse.append, isTrue);
      expect(taskResponse.artifact, isNotNull);
      expect(testResponse1.id, 2);
    });
    test('Send Push Notification Configuration Response Base - Error', () {
      var messageResponse = SetTaskPushNotificationConfigResponse();
      var json = <String, dynamic>{};

      var testResponse = A2AJSONRPCErrorResponsePNCR()
        ..error = A2AError()
        ..id = 1;
      messageResponse = testResponse;
      json = messageResponse.toJson();

      messageResponse = SetTaskPushNotificationConfigResponse();
      messageResponse = SetTaskPushNotificationConfigResponse.fromJson(json);
      expect(messageResponse.isError, true);
      expect(messageResponse is A2AJSONRPCErrorResponsePNCR, isTrue);
      final testResponse1 = messageResponse as A2AJSONRPCErrorResponsePNCR;
      expect(testResponse1.error is A2AError, isTrue);
      expect(testResponse1.id, 1);
    });
    test('Send Push Notification Configuration Response Base - Success', () {
      var messageResponse = SetTaskPushNotificationConfigResponse();
      expect(messageResponse.toJson(), {});
      var json = <String, dynamic>{};

      final config = A2APushNotificationConfig()
        ..id = '2'
        ..token = 'Token';
      var testResponse = A2ASetTaskPushNotificationConfigSuccessResponse()
        ..id = 2
        ..result = config;

      messageResponse = testResponse;
      json = messageResponse.toJson();
      messageResponse = SetTaskPushNotificationConfigResponse();
      messageResponse = SetTaskPushNotificationConfigResponse.fromJson(json);
      expect(
        messageResponse is A2ASetTaskPushNotificationConfigSuccessResponse,
        isTrue,
      );
      final testResponse1 =
          messageResponse as A2ASetTaskPushNotificationConfigSuccessResponse;
      expect(testResponse1.result is A2APushNotificationConfig, isTrue);
      final taskResponse = testResponse1.result as A2APushNotificationConfig;
      expect(taskResponse.id, '2');
      expect(taskResponse.token, 'Token');
      expect(testResponse1.id, 2);
    });
    test('Send Push Notification Configuration Response - Error', () {
      var messageResponse = A2AJsonRpcResponse();
      var json = <String, dynamic>{};

      var testResponse = A2AJSONRPCErrorResponsePNCR()
        ..error = A2AError()
        ..id = 1;
      messageResponse = testResponse;
      json = messageResponse.toJson();

      messageResponse = A2AJsonRpcResponse();
      messageResponse = A2AJsonRpcResponse.fromJson(json);
      expect(messageResponse.isError, true);
      expect(messageResponse is A2AJSONRPCErrorResponseS, isTrue);
      final testResponse1 = messageResponse as A2AJSONRPCErrorResponseS;
      expect(testResponse1.error is A2AError, isTrue);
      expect(testResponse1.id, 1);
    });
    test('Send Push Notification Configuration Response - Success', () {
      var messageResponse = A2AJsonRpcResponse();
      var json = <String, dynamic>{};

      final config = A2APushNotificationConfig()
        ..id = '2'
        ..token = 'Token';
      var testResponse = A2ASetTaskPushNotificationConfigSuccessResponse()
        ..id = 2
        ..result = config;

      messageResponse = testResponse;
      json = messageResponse.toJson();
      messageResponse = A2AJsonRpcResponse();
      messageResponse = A2AJsonRpcResponse.fromJson(json);
      expect(
        messageResponse is A2ASetTaskPushNotificationConfigSuccessResponse,
        isTrue,
      );
      final testResponse1 =
          messageResponse as A2ASetTaskPushNotificationConfigSuccessResponse;
      expect(testResponse1.result is A2APushNotificationConfig, isTrue);
      final taskResponse = testResponse1.result as A2APushNotificationConfig;
      expect(taskResponse.id, '2');
      expect(taskResponse.token, 'Token');
      expect(testResponse1.id, 2);
    });
  });
  group('JSON RPC Request', () {
    test('Request To/From', () {
      final request = A2AJsonRpcRequest()
        ..id = '100'
        ..method = 'post'
        ..params = {'First': 1};
      final json = request.toJson();
      final request1 = A2AJsonRpcRequest.fromJson(json);
      expect(request1.params, {'First': 1});
      expect(request1.id, '100');
      expect(request1.method, 'post');
    });
  });
  group('Parts', () {
    test('A2ATextPart', () {
      var part = A2APart();
      var json = <String, dynamic>{};

      final textPart = A2ATextPart()
        ..metadata = {'First': 1}
        ..text = 'The text';
      part = textPart;
      json = part.toJson();
      part = A2APart();
      part = A2APart.fromJson(json);
      expect(part is A2ATextPart, isTrue);
      final part1 = part as A2ATextPart;
      expect(part1.text, 'The text');
      expect(part1.metadata, {'First': 1});
    });
    test('A2AFilePart', () {
      var part = A2APart();
      var json = <String, dynamic>{};

      final variant = A2AFileWithBytes()
        ..mimeType = 'image'
        ..name = 'The name'
        ..bytes = 'The bytes';
      final filePart = A2AFilePart()
        ..metadata = {'Second': 2}
        ..file = variant as A2AFilePartVariant;
      part = filePart;
      json = part.toJson();
      part = A2APart();
      part = A2APart.fromJson(json);
      expect(part is A2AFilePart, isTrue);
      final part1 = part as A2AFilePart;
      expect(part1.metadata, {'Second': 2});
      final variant1 = part1.file as A2AFileWithBytes;
      expect(variant1.name, 'The name');
      expect(variant1.mimeType, 'image');
      expect(variant1.bytes, 'The bytes');
    });
    test('A2ADataPart', () {
      var part = A2APart();
      expect(part.toJson(), {});
      var json = <String, dynamic>{};

      final dataPart = A2ADataPart()
        ..data = {'First': 1}
        ..metadata = {'Second': 2};
      part = dataPart;
      json = part.toJson();
      part = A2APart();
      part = A2APart.fromJson(json);
      expect(part is A2ADataPart, isTrue);
      final part1 = part as A2ADataPart;
      expect(part1.data, {'First': 1});
      expect(part1.metadata, {'Second': 2});
    });
    test('A2APart unknown part kind', () {
      var part = A2APart();
      var json = <String, dynamic>{};

      final textPart = A2ATextPart()
        ..metadata = {'First': 1}
        ..text = 'The text'
        ..kind = 'unknown';
      part = textPart;
      json = part.toJson();
      part = A2APart();
      part = A2APart.fromJson(json);
      expect(part.toJson(), {});
    });
    test('A2AFilePartVariant - with bytes', () {
      var pVar = A2AFilePartVariant();
      expect(pVar.toJson(), {});
      var json = <String, dynamic>{};

      final bytesPart = A2AFileWithBytes()
        ..name = 'The name'
        ..bytes = 'The bytes'
        ..mimeType = 'image/png';
      pVar = bytesPart;
      json = pVar.toJson();
      pVar = A2AFilePartVariant();
      final bytes = A2AFilePartVariant.fromJson(json);
      expect(bytes is A2AFileWithBytes, isTrue);
      final bytes1 = bytes as A2AFileWithBytes;
      expect(bytes1.mimeType, 'image/png');
      expect(bytes1.bytes, 'The bytes');
      expect(bytes1.name, 'The name');
    });
    test('A2AFilePartVariant - with URI', () {
      var pVar = A2AFilePartVariant();
      var json = <String, dynamic>{};

      final urlPart = A2AFileWithUri()
        ..name = 'The name'
        ..uri = 'The uri'
        ..mimeType = 'image/png';
      pVar = urlPart;
      json = pVar.toJson();
      pVar = A2AFilePartVariant();
      final bytes = A2AFilePartVariant.fromJson(json);
      expect(bytes is A2AFileWithUri, isTrue);
      final bytes1 = bytes as A2AFileWithUri;
      expect(bytes1.mimeType, 'image/png');
      expect(bytes1.uri, 'The uri');
      expect(bytes1.name, 'The name');
    });
  });
  group('Request', () {
    test('A2ASendMessageRequest', () {
      var request = A2ARequest();
      expect(request.toJson(), {});
      var json = <String, dynamic>{};

      var testRequest = A2ASendMessageRequest()..id = 1;
      request = testRequest;
      json = request.toJson();
      request = A2ARequest();
      request = A2ARequest.fromJson(json);
      expect(request is A2ASendMessageRequest, isTrue);
      final request1 = request as A2ASendMessageRequest;
      expect(request1.id, 1);
    });
    test('A2ASendStreamingMessageRequest', () {
      var request = A2ARequest();
      var json = <String, dynamic>{};

      var testRequest = A2ASendStreamingMessageRequest()
        ..id = 1
        ..params = (A2AMessageSendParams()
          ..metadata = {'First': 1}
          ..message = A2AMessage()
          ..configuration = (A2AMessageSendConfiguration()
            ..acceptedOutputModes = ['text']
            ..blocking = true
            ..historyLength = 1
            ..pushNotificationConfig = (A2APushNotificationConfig()
              ..id = 'id'
              ..url = 'url'
              ..token = 'token'
              ..authentication = (A2APushNotificationAuthenticationInfo()
                ..credentials = 'credentials'
                ..schemes = ['scheme1']))));
      request = testRequest;
      json = request.toJson();
      request = A2ARequest();
      request = A2ARequest.fromJson(json);
      expect(request is A2ASendStreamingMessageRequest, isTrue);
      final request1 = request as A2ASendStreamingMessageRequest;
      expect(request1.id, 1);
      expect(request1.params?.metadata, {'First': 1});
      expect(request1.params?.configuration?.historyLength, 1);
      expect(request1.params?.configuration?.acceptedOutputModes, ['text']);
      expect(request1.params?.configuration?.blocking, isTrue);
      expect(
        request1.params?.configuration?.pushNotificationConfig?.token,
        'token',
      );
      expect(
        request1.params?.configuration?.pushNotificationConfig?.url,
        'url',
      );
      expect(request1.params?.configuration?.pushNotificationConfig?.id, 'id');
      expect(
        request1
            .params
            ?.configuration
            ?.pushNotificationConfig
            ?.authentication
            ?.schemes,
        ['scheme1'],
      );
      expect(
        request1
            .params
            ?.configuration
            ?.pushNotificationConfig
            ?.authentication
            ?.credentials,
        'credentials',
      );
    });
    test('A2AGetTaskRequest', () {
      var request = A2ARequest();
      var json = <String, dynamic>{};
      final params = A2ATaskQueryParams()
        ..id = '2'
        ..historyLength = 1
        ..metadata = {'First': 1};
      var testRequest = A2AGetTaskRequest()
        ..id = 1
        ..params = params;
      request = testRequest;
      json = request.toJson();
      request = A2ARequest();
      request = A2ARequest.fromJson(json);
      expect(request is A2AGetTaskRequest, isTrue);
      final request1 = request as A2AGetTaskRequest;
      expect(request1.id, 1);
      expect(request.params?.id, '2');
      expect(request1.params?.historyLength, 1);
      expect(request1.params?.metadata, {'First': 1});
    });
    test('A2ACancelTaskRequest', () {
      var request = A2ARequest();
      var json = <String, dynamic>{};
      final params = A2ATaskIdParams()
        ..id = '2'
        ..metadata = {'First': 1};
      var testRequest = A2ACancelTaskRequest()
        ..id = 1
        ..params = params;
      request = testRequest;
      json = request.toJson();
      request = A2ARequest();
      request = A2ARequest.fromJson(json);
      expect(request is A2ACancelTaskRequest, isTrue);
      final request1 = request as A2ACancelTaskRequest;
      expect(request1.id, 1);
      expect(request.params?.id, '2');
      expect(request1.params?.metadata, {'First': 1});
    });
    test('A2ASetTaskPushNotificationConfigRequest', () {
      var request = A2ARequest();
      var json = <String, dynamic>{};
      final params = A2ATaskPushNotificationConfig()..taskId = '2';
      var testRequest = A2ASetTaskPushNotificationConfigRequest()
        ..id = 1
        ..params = params;
      request = testRequest;
      json = request.toJson();
      request = A2ARequest();
      request = A2ARequest.fromJson(json);
      expect(request is A2ASetTaskPushNotificationConfigRequest, isTrue);
      final request1 = request as A2ASetTaskPushNotificationConfigRequest;
      expect(request1.id, 1);
      expect(request.params?.taskId, '2');
    });
    test('A2AGetTaskPushNotificationConfigRequest', () {
      var request = A2ARequest();
      var json = <String, dynamic>{};
      final params = A2AGetTaskPushNotificationConfigParams()
        ..id = '2'
        ..metadata = {'First': 1};
      var testRequest = A2AGetTaskPushNotificationConfigRequest()
        ..id = 1
        ..params = params;
      request = testRequest;
      json = request.toJson();
      request = A2ARequest();
      request = A2ARequest.fromJson(json);
      expect(request is A2AGetTaskPushNotificationConfigRequest, isTrue);
      final request1 = request as A2AGetTaskPushNotificationConfigRequest;
      expect(request1.id, 1);
      expect(request.params?.id, '2');
      expect(request1.params?.metadata, {'First': 1});
    });
    test('A2ATaskResubscriptionRequest', () {
      var request = A2ARequest();
      var json = <String, dynamic>{};
      final params = A2ATaskIdParams()
        ..id = '2'
        ..metadata = {'First': 1};
      var testRequest = A2ATaskResubscriptionRequest()
        ..id = 1
        ..params = params;
      request = testRequest;
      json = request.toJson();
      request = A2ARequest();
      request = A2ARequest.fromJson(json);
      expect(request is A2ATaskResubscriptionRequest, isTrue);
      final request1 = request as A2ATaskResubscriptionRequest;
      expect(request1.id, 1);
      expect(request.params?.id, '2');
      expect(request1.params?.metadata, {'First': 1});
    });
  });
  group('Send Stream Message Response', () {
    test('A2ASendMessageRequest - Error', () {
      var messageResponse = A2ASendStreamMessageResponse();
      expect(messageResponse.toJson(), {});
      var json = <String, dynamic>{};

      var testResponse = A2AJSONRPCErrorResponseSSM()
        ..error = A2AError()
        ..id = 1;
      messageResponse = testResponse;
      json = messageResponse.toJson();

      messageResponse = A2ASendStreamMessageResponse();
      messageResponse = A2ASendStreamMessageResponse.fromJson(json);
      expect(messageResponse.isError, true);
      expect(messageResponse is A2AJSONRPCErrorResponseSSM, isTrue);
      final testResponse1 = messageResponse as A2AJSONRPCErrorResponseSSM;
      expect(testResponse1.error is A2AError, isTrue);
      expect(testResponse1.id, 1);
    });
    test('Send Stream Message Response - Success - Task', () {
      var messageResponse = A2ASendStreamMessageResponse();
      var json = <String, dynamic>{};

      final task = A2ATask()
        ..id = '3'
        ..status = A2ATaskStatus()
        ..contextId = 'Context id';
      var testResponse = A2ASendStreamMessageSuccessResponse()
        ..id = 2
        ..result = task;

      messageResponse = testResponse;
      json = messageResponse.toJson();
      messageResponse = A2ASendStreamMessageResponse();
      messageResponse = A2ASendStreamMessageResponse.fromJson(json);
      expect(messageResponse is A2ASendStreamMessageSuccessResponse, isTrue);
      final testResponse1 =
          messageResponse as A2ASendStreamMessageSuccessResponse;
      expect(testResponse1.result is A2ATask, isTrue);
      expect(testResponse1.id, 2);
      final taskResponse = testResponse1.result as A2ATask;
      expect(taskResponse.contextId, 'Context id');
      expect(taskResponse.id, '3');
      expect(taskResponse.status is A2ATaskStatus, isTrue);
      expect(testResponse1.id, 2);
    });
    test('Send Stream Message Response - Success - Message', () {
      var messageResponse = A2ASendStreamMessageResponse();
      var json = <String, dynamic>{};

      final message = A2AMessage()
        ..metadata = {'First': 1}
        ..extensions = ['text']
        ..taskId = '2'
        ..messageId = '100'
        ..contextId = '300'
        ..parts = [A2ATextPart()];
      var testResponse = A2ASendStreamMessageSuccessResponse()
        ..id = 2
        ..result = message;

      messageResponse = testResponse;
      json = messageResponse.toJson();
      messageResponse = A2ASendStreamMessageResponse();
      messageResponse = A2ASendStreamMessageResponse.fromJson(json);
      expect(messageResponse is A2ASendStreamMessageSuccessResponse, isTrue);
      final testResponse1 =
          messageResponse as A2ASendStreamMessageSuccessResponse;
      expect(testResponse1.result is A2AMessage, isTrue);
      expect(testResponse1.id, 2);
      final taskResponse = testResponse1.result as A2AMessage;
      expect(taskResponse.contextId, '300');
      expect(taskResponse.taskId, '2');
      expect(taskResponse.parts?.length, 1);
      expect(taskResponse.messageId, '100');
      expect(taskResponse.extensions, ['text']);
      expect(taskResponse.metadata, {'First': 1});
    });
    test(
      'Send Stream Message Response - Success = Task Status Update Event',
      () {
        var updateResponse = A2ASendStreamMessageResponse();
        var json = <String, dynamic>{};

        final update = A2ATaskStatusUpdateEvent()
          ..metadata = {'First': 1}
          ..contextId = '300'
          ..taskId = '2'
          ..end = true
          ..status = A2ATaskStatus();
        var testResponse = A2ASendStreamMessageSuccessResponse()
          ..id = 2
          ..result = update;

        updateResponse = testResponse;
        json = updateResponse.toJson();
        updateResponse = A2ASendStreamMessageResponse();
        updateResponse = A2ASendStreamMessageResponse.fromJson(json);
        expect(updateResponse is A2ASendStreamMessageSuccessResponse, isTrue);
        final testResponse1 =
            updateResponse as A2ASendStreamMessageSuccessResponse;
        expect(testResponse1.result is A2ATaskStatusUpdateEvent, isTrue);
        expect(testResponse1.id, 2);
        final taskResponse = testResponse1.result as A2ATaskStatusUpdateEvent;
        expect(taskResponse.contextId, '300');
        expect(taskResponse.taskId, '2');
        expect(taskResponse.end, isTrue);
        expect(taskResponse.metadata, {'First': 1});
      },
    );
    test(
      'Send Stream Message Response - Success = Task Artifact Update Event',
      () {
        var updateResponse = A2ASendStreamMessageResponse();
        var json = <String, dynamic>{};

        final update = A2ATaskArtifactUpdateEvent()
          ..metadata = {'First': 1}
          ..contextId = '300'
          ..taskId = '2'
          ..append = false
          ..artifact = A2AArtifact();
        var testResponse = A2ASendStreamMessageSuccessResponse()
          ..id = 2
          ..result = update;

        updateResponse = testResponse;
        json = updateResponse.toJson();
        updateResponse = A2ASendStreamMessageResponse();
        updateResponse = A2ASendStreamMessageResponse.fromJson(json);
        expect(updateResponse is A2ASendStreamMessageSuccessResponse, isTrue);
        final testResponse1 =
            updateResponse as A2ASendStreamMessageSuccessResponse;
        expect(testResponse1.result is A2ATaskArtifactUpdateEvent, isTrue);
        expect(testResponse1.id, 2);
        final taskResponse = testResponse1.result as A2ATaskArtifactUpdateEvent;
        expect(taskResponse.contextId, '300');
        expect(taskResponse.taskId, '2');
        expect(taskResponse.append, isFalse);
        expect(taskResponse.metadata, {'First': 1});
        expect(taskResponse.artifact, isNotNull);
      },
    );
    test('Send Stream Message Response - Success - Unknown kind', () {
      var updateResponse = A2ASendStreamMessageResponse();
      var json = <String, dynamic>{};

      final update = A2ATaskArtifactUpdateEvent()
        ..metadata = {'First': 1}
        ..contextId = '300'
        ..taskId = '2'
        ..append = false
        ..artifact = A2AArtifact()
        ..kind = 'unknown';
      var testResponse = A2ASendStreamMessageSuccessResponse()
        ..id = 2
        ..result = update;

      updateResponse = testResponse;
      json = updateResponse.toJson();
      updateResponse = A2ASendStreamMessageResponse();
      updateResponse = A2ASendStreamMessageResponse.fromJson(json);
      expect(updateResponse is A2ASendStreamMessageSuccessResponse, isTrue);
    });
  });
  group('Task Push Notification Config Message Response', () {
    test('A2ASetTaskPushNotificationConfigResponse - Error', () {
      var messageResponse = A2ASetTaskPushNotificationConfigResponse();
      expect(messageResponse.toJson(), {});
      var json = <String, dynamic>{};

      var testResponse = A2AJSONRPCErrorResponseSTPR()
        ..error = A2AError()
        ..id = 1;
      messageResponse = testResponse;
      json = messageResponse.toJson();

      messageResponse = A2ASetTaskPushNotificationConfigResponse();
      messageResponse = A2ASetTaskPushNotificationConfigResponse.fromJson(json);
      expect(messageResponse.isError, true);
      expect(messageResponse is A2AJSONRPCErrorResponseSTPR, isTrue);
      final testResponse1 = messageResponse as A2AJSONRPCErrorResponseSTPR;
      expect(testResponse1.error is A2AError, isTrue);
      expect(testResponse1.id, 1);
    });
    test('A2ASetTaskPushNotificationConfigResponse - Success', () {
      var messageResponse = A2ASetTaskPushNotificationConfigResponse();
      var json = <String, dynamic>{};

      final config = A2ATaskPushNotificationConfig()..taskId = '3';
      var testResponse = A2ASetTaskPushNotificationConfigSuccessResponseSTPR()
        ..id = 2
        ..result = config;

      messageResponse = testResponse;
      json = messageResponse.toJson();
      messageResponse = A2ASetTaskPushNotificationConfigResponse();
      messageResponse = A2ASetTaskPushNotificationConfigResponse.fromJson(json);
      expect(
        messageResponse is A2ASetTaskPushNotificationConfigSuccessResponseSTPR,
        isTrue,
      );
      final testResponse1 =
          messageResponse
              as A2ASetTaskPushNotificationConfigSuccessResponseSTPR;
      expect(testResponse1.result is A2ATaskPushNotificationConfig, isTrue);
      final taskResponse =
          testResponse1.result as A2ATaskPushNotificationConfig;
      expect(taskResponse.taskId, '3');
      expect(testResponse1.id, 2);
    });
  });
}
