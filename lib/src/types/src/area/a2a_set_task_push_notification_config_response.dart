/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// JSON-RPC response for the 'tasks/pushNotificationConfig/set' method.
base class A2ASetTaskPushNotificationConfigResponse {}

final class A2AJSONRPCErrorResponseSTPR
    extends A2ASetTaskPushNotificationConfigResponse
    with A2AJSONRPCErrorResponseM {}

final class A2ASetTaskPushNotificationConfigSuccessResponseSTPR
    extends A2ASetTaskPushNotificationConfigResponse {}
