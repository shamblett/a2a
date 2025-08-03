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
  group('Cancel Task Response', () {
    test('A2AJSONRPCErrorResponse', () {
      var cancelTaskResponse = A2ACancelTaskResponse();
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
    test('A2AJSONRPCError', () {
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
        ..result = A2ATaskPushNotificationConfig1()
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
      expect(testResponse1.result is A2ATaskPushNotificationConfig1, isTrue);
      expect(testResponse1.id, 2);
    });
  });
  group('Task Response', () {
    test('A2AJSONRPCErrorResponseT', () {
      var taskResponse = A2AGetTaskResponse();
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
    test('Send Message Response - Error', () {
      var messageResponse = A2AJsonRpcResponse();
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
    test('Send Message Response - Success', () {
      var messageResponse = A2AJsonRpcResponse();
      var json = <String, dynamic>{};

      final task = A2ATask()
        ..id = '3'
        ..status = A2ATaskStatus()
        ..contextId = 'Context id';
      var testResponse = A2ASendMessageSuccessResponse()
        ..id = 2
        ..result = task;

      messageResponse = testResponse;
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
    test('Send Streaming Message Response - Error', () {
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
    test('Send Streaming Message Response - Success', () {
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

      final config = A2ATaskPushNotificationConfig1()
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
      expect(testResponse1.result is A2ATaskPushNotificationConfig1, isTrue);
      final taskResponse =
          testResponse1.result as A2ATaskPushNotificationConfig1;
      expect(taskResponse.id, '2');
      expect(taskResponse.token, 'Token');
      expect(testResponse1.id, 2);
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
  });
  group('Request', () {
    test('A2ASendMessageRequest', () {
      var request = A2ARequest();
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

      var testRequest = A2ASendStreamingMessageRequest()..id = 1;
      request = testRequest;
      json = request.toJson();
      request = A2ARequest();
      request = A2ARequest.fromJson(json);
      expect(request is A2ASendStreamingMessageRequest, isTrue);
      final request1 = request as A2ASendStreamingMessageRequest;
      expect(request1.id, 1);
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
      final params = A2ATaskPushNotificationConfig()..id = '2';
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
      expect(request.params?.id, '2');
    });
    test('A2AGetTaskPushNotificationConfigRequest', () {
      var request = A2ARequest();
      var json = <String, dynamic>{};
      final params = A2ATaskIdParams()
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
      var messageResponse = A2ASendStreamMessageResponse()
      ..isError = true
      ..error = A2AJSONRPCError();
      var json = <String, dynamic>{};
      json = messageResponse.toJson();

      messageResponse = A2ASendStreamMessageResponse.fromJson(json);
      expect(messageResponse.isError, true);
      final testResponse1 = messageResponse.error as A2AJSONRPCError;
      expect(testResponse1.rpcErrorCode, 0);
    });
    test('Send Stream Message Response - Success', () {
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
      messageResponse = A2ASendStreamMessageSuccessResponse.fromJson(json);
      expect(messageResponse is A2ASendStreamMessageSuccessResponse, isTrue);
      final testResponse1 =
          messageResponse as A2ASendStreamMessageSuccessResponse;
      expect(testResponse1.result is A2ATask, isTrue);
      final taskResponse = testResponse1.result as A2ATask;
      expect(taskResponse.contextId, 'Context id');
      expect(taskResponse.id, '3');
      expect(taskResponse.status is A2ATaskStatus, isTrue);
      expect(testResponse1.id, 2);
    });
  });
  group('Task Push Notification Config Message Response', () {
    test('A2ASetTaskPushNotificationConfigResponse - Error', () {
      var messageResponse = A2ASetTaskPushNotificationConfigResponse();
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

      final config = A2ATaskPushNotificationConfig()..id = '3';
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
      expect(taskResponse.id, '3');
      expect(testResponse1.id, 2);
    });
  });
}
