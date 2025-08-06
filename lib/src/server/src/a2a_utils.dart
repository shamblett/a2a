/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../a2a_server.dart';

/// Generates a timestamp in ISO 8601 format.
/// @returns The current timestamp as a string.
String getCurrentTimestamp() {
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
