/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../a2a_types.dart';

/// Server utilities class
class A2AUtilities {
  /// Generates a timestamp in ISO 8601 format.
  /// @returns The current timestamp as a string.
  static String getCurrentTimestamp() {
    final dt = DateTime.now();
    // Lose the microsecond component
    final tmp = DateTime(
      dt.year,
      dt.month,
      dt.day,
      dt.hour,
      dt.minute,
      dt.second,
      dt.millisecond,
      0,
    );
    return tmp.toIso8601String();
  }

  /// Type guard to check if an object is a TaskStatus update (lacks 'parts').
  /// Used to differentiate yielded updates from the handler.
  static bool isTaskStatusUpdate(Object update) => update is A2ATaskStatus;

  /// Type guard to check if an object is an Artifact update (has 'parts').
  /// Used to differentiate yielded updates from the handler.
  static bool isTaskArtifactUpdate(Object update) => update is A2AArtifact;
}
