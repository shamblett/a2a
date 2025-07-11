/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

base class A2AGetTaskPushNotificationConfigResponse {}

final class JSONRPCErrorResponseTP
    extends A2AGetTaskPushNotificationConfigResponse
    with JSONRPCErrorResponseM {}

final class GetTaskPushNotificationConfigSuccessResponse
    extends A2AGetTaskPushNotificationConfigResponse {}
