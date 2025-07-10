/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// A2A supported request types
base class A2ARequest {}

final class SendMessageRequest extends A2ARequest {}

final class SendStreamingMessageRequest extends A2ARequest {}

final class GetTaskRequest extends A2ARequest {}

final class CancelTaskRequest extends A2ARequest {}

final class SetTaskPushNotificationConfigRequest extends A2ARequest {}

final class GetTaskPushNotificationConfigRequest extends A2ARequest {}

final class TaskResubscriptionRequest extends A2ARequest {}
