/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../types.dart';

class A2AType {}

/// The ID type
typedef Id = (String, num);

/// Represents the possible states of a Task.
enum TaskState {
  submitted,
  working,
  inputRequired,
  completed,
  canceled,
  failed,
  rejected,
  authRequired,
  unknown,
}
