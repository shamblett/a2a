/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

import 'package:a2a/src/server/a2a_server.dart';
import 'package:colorize/colorize.dart';

/// For testing only
class A2ATestAgentExecutor implements A2AAgentExecutor {
  @override
  Future<void> execute(
    A2ARequestContext requestContext,
    A2AExecutionEventBus eventBus,
  ) async {
    print('${Colorize('A2ATestAgentExecutor EXECUTE invoked')..bgBlue()}');
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Future<void> cancelTask(String taskId, A2AExecutionEventBus eventBus) async {
    print('${Colorize('A2ATestAgentExecutor Cancel Task invoked')..bgBlue()}');
    await Future.delayed(Duration(seconds: 1));
  }
}
