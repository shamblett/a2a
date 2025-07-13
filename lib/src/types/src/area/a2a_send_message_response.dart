/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// JSON-RPC response model for the 'message/send' method.
base class A2ASendMessageResponse {}

final class A2AJSONRPCErrorResponseSM extends A2ASendMessageResponse
    with A2AJSONRPCErrorResponseM {}

final class A2ASendMessageSuccessResponseR extends A2ASendMessageResponse {}
