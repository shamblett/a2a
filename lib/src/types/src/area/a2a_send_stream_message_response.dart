/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../types.dart';

/// JSON-RPC response model for the 'message/send' method.
sealed class A2ASendStreamMessageResponse {}

final class A2AJSONRPCErrorResponseSSM extends A2ASendStreamMessageResponse
    with A2AJSONRPCErrorResponseM {}

final class A2ASendStreamMessageSuccessResponseR
    extends A2ASendStreamMessageResponse {}
