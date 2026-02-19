/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 19/02/2026
* Copyright :  S.Hamblett
*/

import 'dart:convert';
import 'package:genai_primitives/genai_primitives.dart';
import '../../types/a2a_types.dart';

/// Extension to map genai_primitives ChatMessage to A2AMessage
extension A2AChatMessageMapper on ChatMessage {
  /// Converts a [ChatMessage] to an [A2AMessage].
  A2AMessage toA2AMessage({String? taskId, String? contextId}) {
    final a2aMessage = A2AMessage();

    // Map role
    switch (role) {
      case ChatMessageRole.user:
        a2aMessage.role = 'user';
        break;
      case ChatMessageRole.model:
        a2aMessage.role = 'agent';
        break;
      case ChatMessageRole.system:
        a2aMessage.role = 'system';
        break;
    }

    a2aMessage.taskId = taskId;
    a2aMessage.contextId = contextId;

    // Map parts
    if (parts.isNotEmpty) {
      a2aMessage.parts = [];
      for (final part in parts) {
        if (part is TextPart) {
          final a2aPart = A2ATextPart()..text = part.text;
          a2aMessage.parts!.add(a2aPart);
        } else if (part is DataPart) {
          // Map to A2AFilePart with bytes
          final a2aPart = A2AFilePart();
          final fileVariant = A2AFileWithBytes();
          fileVariant.bytes = base64Encode(part.bytes);
          fileVariant.mimeType = part.mimeType;
          fileVariant.name = part.name ?? '';
          a2aPart.file = fileVariant;
          a2aMessage.parts!.add(a2aPart);
        } else if (part is LinkPart) {
          // Map to A2AFilePart with URI
          final a2aPart = A2AFilePart();
          final fileVariant = A2AFileWithUri();
          fileVariant.uri = part.url.toString();
          fileVariant.mimeType = part.mimeType ?? '';
          fileVariant.name = part.name ?? '';
          a2aPart.file = fileVariant;
          a2aMessage.parts!.add(a2aPart);
        }
      }
    }

    return a2aMessage;
  }
}
