/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

@TestOn('vm')
library;

import 'package:a2a/a2a.dart';
import 'package:test/test.dart';

import 'package:a2a/src/server/a2a_server.dart';

void main() {
  group('Utilities', () {
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
  });
}
