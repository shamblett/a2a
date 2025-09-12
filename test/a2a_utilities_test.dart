/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

@TestOn('vm')
library;

import 'package:test/test.dart';

import 'package:a2a/src/server/a2a_server.dart';

void main() {
  test('getCurrentTimestamp', () {
    final dt = A2AUtilities.getCurrentTimestamp();
    expect(dt.length, 'yyyy-MM-ddTHH:mm:ss.mmm'.length);
  });
  test('isTaskStatusUpdate', () {
    expect(A2AUtilities.isTaskStatusUpdate(A2ATaskStatus()), isTrue);
    expect(A2AUtilities.isTaskStatusUpdate(A2ATask()), isFalse);
  });
  test('isTaskArtifactUpdate', () {
    expect(A2AUtilities.isTaskArtifactUpdate(A2AArtifact()), isTrue);
    expect(A2AUtilities.isTaskArtifactUpdate(A2AMessage()), isFalse);
  });
  test('decodeParts', () {
    final dataPart = A2ADataPart();
    final filePart = A2AFilePart();
    final tp1 = A2ATextPart()..text = 'Text Part 1';
    final tp2 = A2ATextPart()..text = 'Text Part 2';
    final nullDecode = A2AUtilities.decodeParts(null);
    expect(nullDecode.allText.isEmpty, isTrue);
    expect(nullDecode.fileParts.isEmpty, isTrue);
    expect(nullDecode.dataParts.isEmpty, isTrue);
    expect(nullDecode.textPartText.isEmpty, isTrue);
    expect(nullDecode.textParts.isEmpty, isTrue);
    final parts = [dataPart, filePart, tp1, tp2];
    final decode = A2AUtilities.decodeParts(parts);
    expect(decode.allText, 'Text Part 1Text Part 2');
    expect(decode.fileParts.length, 1);
    expect(decode.dataParts.length, 1);
    expect(decode.textPartText, ['Text Part 1', 'Text Part 2']);
    expect(decode.textParts.length, 2);
  });
}
