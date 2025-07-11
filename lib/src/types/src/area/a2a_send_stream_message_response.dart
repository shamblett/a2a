/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// JSON-RPC response model for the 'message/send' method.
base class A2ASendStreamMessageResponse {}

final class JSONRPCErrorResponseSSM extends A2ASendStreamMessageResponse
    with JSONRPCErrorResponseM {}

final class SendStreamMessageSuccessResponseR
    extends A2ASendStreamMessageResponse {}
