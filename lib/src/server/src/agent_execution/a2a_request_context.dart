/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../../a2a_server.dart';

class A2ARequestContext {
  A2AMessage userMessage;
  A2ATask? task;
  List<A2ATask>? referenceTasks;
  String taskId;
  String contextId;

  A2ARequestContext(
    this.userMessage,
    this.task,
    this.referenceTasks,
    this.taskId,
    this.contextId,
  );
}
