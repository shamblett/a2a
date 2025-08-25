/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_server.dart';

/// A2A Server debug support class
class A2AServerDebug {
  static bool _debug = false;

  static bool get isOn => _debug;

  static void on() {
    _debug = true;
  }

  static void off() {
    _debug = false;
  }

  /// Pretty print a JSON map
  static String printJson(dynamic json) {
    var spaces = ' ' * 2;
    var encoder = JsonEncoder.withIndent(spaces);
    return encoder.convert(json);
  }
}
