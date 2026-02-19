import 'dart:convert';
import 'package:test/test.dart';
import 'package:genai_primitives/genai_primitives.dart';
import 'package:a2a/a2a.dart';
// ignore: implementation_imports
import 'package:a2a/src/client/src/a2a_chat_message_mapper.dart';

void main() {
  group('ChatMessage to A2AMessage Mapping', () {
    test('Maps simple user text message', () {
      final chatMessage = ChatMessage.user('Hello world');
      final a2aMessage = chatMessage.toA2AMessage();

      expect(a2aMessage.role, equals('user'));
      expect(a2aMessage.parts!.length, equals(1));
      expect(a2aMessage.parts![0], isA<A2ATextPart>());
      expect((a2aMessage.parts![0] as A2ATextPart).text, equals('Hello world'));
    });

    test('Maps model message', () {
      final chatMessage = ChatMessage.model('I am a bot');
      final a2aMessage = chatMessage.toA2AMessage();

      expect(a2aMessage.role, equals('agent'));
      expect(a2aMessage.parts!.length, equals(1));
    });

    test('Maps system message', () {
      final chatMessage = ChatMessage.system('Be helpful');
      final a2aMessage = chatMessage.toA2AMessage();

      expect(a2aMessage.role, equals('system'));
      expect(a2aMessage.parts!.length, equals(1));
    });

    test('Maps message with taskId and contextId', () {
      final chatMessage = ChatMessage.user('Hi');
      final a2aMessage = chatMessage.toA2AMessage(
        taskId: 'task1',
        contextId: 'ctx1',
      );

      expect(a2aMessage.taskId, equals('task1'));
      expect(a2aMessage.contextId, equals('ctx1'));
    });

    test('Maps DataPart to A2AFilePart with bytes', () {
      final bytes = utf8.encode('some data');
      final dataPart = DataPart(
        bytes,
        mimeType: 'text/plain',
        name: 'test.txt',
      );
      final chatMessage = ChatMessage(
        role: ChatMessageRole.user,
        parts: [dataPart],
      );

      final a2aMessage = chatMessage.toA2AMessage();
      expect(a2aMessage.parts!.length, equals(1));
      expect(a2aMessage.parts![0], isA<A2AFilePart>());
      final filePart = a2aMessage.parts![0] as A2AFilePart;
      expect(filePart.file, isA<A2AFileWithBytes>());
      final fileBytes = filePart.file as A2AFileWithBytes;
      expect(fileBytes.bytes, equals(base64Encode(bytes)));
      expect(fileBytes.mimeType, equals('text/plain'));
      expect(fileBytes.name, equals('test.txt'));
    });

    test('Maps LinkPart to A2AFilePart with URI', () {
      final uri = Uri.parse('https://example.com/image.png');
      final linkPart = LinkPart(uri, mimeType: 'image/png', name: 'image.png');
      final chatMessage = ChatMessage(
        role: ChatMessageRole.user,
        parts: [linkPart],
      );

      final a2aMessage = chatMessage.toA2AMessage();
      expect(a2aMessage.parts!.length, equals(1));
      expect(a2aMessage.parts![0], isA<A2AFilePart>());
      final filePart = a2aMessage.parts![0] as A2AFilePart;
      expect(filePart.file, isA<A2AFileWithUri>());
      final fileUri = filePart.file as A2AFileWithUri;
      expect(fileUri.uri, equals('https://example.com/image.png'));
      expect(fileUri.mimeType, equals('image/png'));
      expect(fileUri.name, equals('image.png'));
    });
  });
}
