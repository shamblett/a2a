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

/// Structured value type
typedef SV = Map<String,Object>;

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

interface class MySchema {
  Map<String,Object> unknown = {};
}
