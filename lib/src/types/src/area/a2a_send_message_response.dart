/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// JSON-RPC response model for the 'message/send' method.
base class A2ASendMessageResponse {}

final class JSONRPCErrorResponseSM extends A2ASendMessageResponse
    with JSONRPCErrorResponseM {}

final class SendMessageSuccessResponseR extends A2ASendMessageResponse {}
