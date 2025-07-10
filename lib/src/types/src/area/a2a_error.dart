/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// A2A supported error types
base class A2AError {}

final class JSONParseError extends A2AError {}

final class InvalidRequestError extends A2AError {}

final class MethodNotFoundError extends A2AError {}

final class InvalidParamsError extends A2AError {}

final class InternalError extends A2AError {}

final class TaskNotFoundError extends A2AError {}

final class TaskNotCancelableError extends A2AError {}

final class PushNotificationNotSupportedError extends A2AError {}

final class UnsupportedOperationError extends A2AError {}

final class ContentTypeNotSupportedError extends A2AError {}

final class InvalidAgentResponseError extends A2AError {}
