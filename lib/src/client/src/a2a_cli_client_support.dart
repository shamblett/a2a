/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../a2a_client.dart';

///
/// Support class for the A2A CLI Client
///
class A2ACLIClientSupport {
  /// The client and its base URL
  static A2AClient? client;
  static String baseUrl = '';

  /// Agent name
  static String agentName =
      'Agent'; // Default, try to get from agent card later

  /// Streaming support
  static bool agentSupportsStreaming = false;

  /// State
  static String currentTaskId = '';
  static String currentContextId = '';

  /// Uuid
  static final uuid = Uuid();

  /// No streaming
  static bool noStreaming = false;

  /// Utility function to check if the base URL is
  /// remote or on local host. Note remote means not localhost
  /// or 127.0.0.1
  static bool isBaseUrlRemote() {
    if (A2ACLIClientSupport.baseUrl.contains('localhost') ||
        A2ACLIClientSupport.baseUrl.contains('127.0.0.1')) {
      return false;
    }
    return true;
  }

  /// Fetch and display the agent card
  static Future<void> fetchAnDisplayAgentCard() async {
    // Construct the client, this will fetch the agent card
    try {
      A2ACLIClientSupport.client = A2AClient(A2ACLIClientSupport.baseUrl);
      // Delay a little longer if the agent is remote
      if (A2ACLIClientSupport.isBaseUrlRemote()) {
        await Future.delayed(Duration(seconds: 5));
      } else {
        await Future.delayed(Duration(seconds: 1));
      }
    } catch (e) {
      print(
        '${Colorize('Fatal error constructing client...please try again')..red()}',
      );
      exit(-1);
    }

    // Get the cached agent card
    try {
      final card = await A2ACLIClientSupport.client!.getAgentCard();
      print('${Colorize('✓ Agent Card Found')..green()}');
      A2ACLIClientSupport.agentName = card.name;
      print('  Agent Name : ${A2ACLIClientSupport.agentName}');
      if (card.description.isNotEmpty) {
        print('  Description : ${card.description}');
      }
      if (card.version.isNotEmpty) {
        print('  Version : ${card.version}');
      }
      if (card.capabilities.streaming == true) {
        print('${Colorize('  Streaming supported')..green()}');
        A2ACLIClientSupport.agentSupportsStreaming = true;
      } else {
        print(
          '${Colorize('  ❌ Streaming not supported or not specified')..yellow()}',
        );
        print(
          '${Colorize('  Client will fallback to using non streaming API calls')..dark()}',
        );
      }
    } catch (e) {
      print(
        '${Colorize('Error fetching or parsing the agent card')..yellow()}',
      );
      rethrow;
    }
  }

  /// Read a line from the terminal
  /// Returns an empty string if no line is entered
  static String readLine() {
    final prompt = Colorize('${A2ACLIClientSupport.agentName} > You : ')
      ..cyan();
    print('');
    print(prompt);
    print('');
    final input = stdin.readLineSync();
    if (input == null) {
      return '';
    }
    return input.trim();
  }

  /// Id generator
  static String generateId() => A2ACLIClientSupport.uuid.v4();

  /// Task progress
  static String generateTaskProgress(String prefix, A2ATaskState state) {
    String output;
    switch (state) {
      case A2ATaskState.submitted:
        final stateString = Colorize(state.name)..blue();
        output = '$prefix 🚧 Status : $stateString';
      case A2ATaskState.working:
        final stateString = Colorize(state.name)..blue();
        output = '$prefix ⏳ Status : $stateString ';
      case A2ATaskState.inputRequired:
        final stateString = Colorize(state.name)..yellow();
        output = '$prefix 🤔 Status : $stateString ';
      case A2ATaskState.completed:
        final stateString = Colorize(state.name)..green();
        output = '$prefix ✅ Status : $stateString ';
      case A2ATaskState.canceled:
        final stateString = Colorize(state.name)..darkGray();
        output = '$prefix ⏹️ Status : $stateString ';
      case A2ATaskState.failed:
        final stateString = Colorize(state.name)..red();
        output = '$prefix x Status : $stateString ';
      default:
        final stateString = Colorize(state.name)..dark();
        output = '$prefix ℹ️ Status : $stateString ';
    }
    return output;
  }

  /// Print a messages's content
  static void printMessageContent(A2AMessage? message) {
    int index = 0;
    if (message == null) {
      print('${Colorize('Cannot print message, message is null').yellow}');
      return;
    }
    if (message.parts != null) {
      final partPrefix = '${Colorize('Part ${index + 1}:')..red()}';
      for (final part in message.parts!) {
        if (part is A2ATextPart) {
          print('$partPrefix ${Colorize('📝 Text:')..green()}, ${part.text}');
        } else if (part is A2AFilePart) {
          String name = '';
          String mimeType = '';
          String variant = '';
          if (part.file is A2AFileWithBytes) {
            final tmp = part.file as A2AFileWithBytes;
            name = tmp.name;
            mimeType = tmp.mimeType;
            variant = 'Inline Bytes';
          } else {
            if (part.file is A2AFileWithUri) {
              final tmp = part.file as A2AFileWithUri;
              name = tmp.name;
              mimeType = 'N/A';
              variant = tmp.uri;
            }
          }
          print(
            '$partPrefix ${Colorize('📄 File:')..blue()}, Name: $name, Type: $mimeType, Source: $variant',
          );
        } else if (part is A2ADataPart) {
          print('$partPrefix ${Colorize('📊 Data: ')..yellow()}, $part.data');
        }
      }
    } else {
      print('${Colorize('No parts in message').yellow}');
    }
  }

  /// Print an artifacts content
  static void printArtifactContent(A2AArtifact? artifact) {
    int index = 0;
    if (artifact == null) {
      print('${Colorize('Cannot print message, message is null').yellow}');
      return;
    }

    for (final part in artifact.parts) {
      final partPrefix = '${Colorize('Part ${index + 1}:')..red()}';
      if (part is A2ATextPart) {
        print('$partPrefix ${Colorize('📝 Text:')..green()}, ${part.text}');
      } else if (part is A2AFilePart) {
        String name = '';
        String mimeType = '';
        String variant = '';
        if (part.file is A2AFileWithBytes) {
          final tmp = part.file as A2AFileWithBytes;
          name = tmp.name;
          mimeType = tmp.mimeType;
          variant = 'Inline Bytes';
        } else {
          if (part.file is A2AFileWithUri) {
            final tmp = part.file as A2AFileWithUri;
            name = tmp.name;
            mimeType = 'N/A';
            variant = tmp.uri;
          }
        }
        print(
          '$partPrefix ${Colorize('📄 File:')..blue()}, Name: $name, Type: $mimeType, Source: $variant',
        );
      } else if (part is A2ADataPart) {
        print('$partPrefix ${Colorize('📊 Data: ')..yellow()}, $part.data');
      }
      index++;
    }
  }

  /// Common print support
  static void commonPrintHandling(Object event) {
    final timestamp = DateTime.now()
      ..toLocal(); // Get fresh timestamp for each event
    final prefix = Colorize('${A2ACLIClientSupport.agentName} $timestamp :')
      ..magenta();
    String output = '';

    if (event is A2ATask) {
      final update = event;
      final state = update.status?.state;
      print('');
      print('${prefix.toString()} ${Colorize('Task Stream Event').blue()}');
      if (update.id != A2ACLIClientSupport.currentTaskId) {
        print(
          '${Colorize('Task Id updated from ${A2ACLIClientSupport.currentTaskId.isEmpty ? '<none>' : A2ACLIClientSupport.currentTaskId} to ${update.id}')..dark()}',
        );
        A2ACLIClientSupport.currentTaskId = update.id;
      }
      if (update.contextId != A2ACLIClientSupport.currentContextId) {
        print(
          '${Colorize('Context Id updated from ${A2ACLIClientSupport.currentContextId.isEmpty ? '<none>' : A2ACLIClientSupport.currentContextId} to ${update.contextId}')..dark()}',
        );
        A2ACLIClientSupport.currentContextId = update.contextId;
      }
      if (update.status?.message != null) {
        A2ACLIClientSupport.printMessageContent(update.status?.message);
      }
      if (update.artifacts != null && update.artifacts?.isNotEmpty == true) {
        print('${Colorize('   Task includes artifacts:')..darkGray()}');
      }
      output = A2ACLIClientSupport.generateTaskProgress(
        prefix.toString(),
        state!,
      );
      output += '(  Task: ${update.id}, Context: ${update.contextId}';
      print(output);
    } else if (event is A2ATaskStatusUpdateEvent) {
      final update = event;
      final state = update.status?.state;

      // If the event is a TaskStatusUpdateEvent and it's final, reset currentTaskId and
      // context id
      if (update.end == true) {
        A2ACLIClientSupport.currentContextId = '';
        A2ACLIClientSupport.currentTaskId = '';
        print(
          '${Colorize('Task ${update.taskId} is FINAL. Clearing current task ID.')..yellow()}',
        );
      }
      output = A2ACLIClientSupport.generateTaskProgress(
        prefix.toString(),
        state!,
      );
      output += '(  Task: ${update.taskId}, Context: ${update.contextId}';
      print(output);
      if (update.status?.message != null) {
        A2ACLIClientSupport.printMessageContent(update.status?.message);
      }
    } else if (event is A2ATaskArtifactUpdateEvent) {
      final update = event;
      print(
        '${Colorize('Task artifact update event received for task ${update.taskId}')..yellow()}',
      );
      A2ACLIClientSupport.printArtifactContent(update.artifact);
    } else if (event is A2AMessage) {
      final update = event;
      print(
        '${prefix.toString()} ${Colorize('✉️ Message Stream Event:')..green()}',
      );
      A2ACLIClientSupport.printMessageContent(update);
      if (update.taskId != null) {
        if (update.taskId != A2ACLIClientSupport.currentTaskId) {
          print(
            '${Colorize('Task ID updated from ${A2ACLIClientSupport.currentTaskId} to ${update.taskId} from message event')..dark()}',
          );
          A2ACLIClientSupport.currentTaskId = update.taskId!;
        }
      }
      if (update.contextId != null) {
        if (update.contextId != A2ACLIClientSupport.currentContextId) {
          print(
            '${Colorize('Context ID updated from ${A2ACLIClientSupport.currentContextId} to ${update.contextId} from message event')..dark()}',
          );
          A2ACLIClientSupport.currentContextId = update.contextId!;
        }
      }
    } else {
      print(
        '${Colorize('Received unknown event structure from stream: $event')..yellow()}',
      );
    }
  }

  /// Print agent event stream
  static void printAgentEventStreaming(
    A2ASendStreamMessageSuccessResponse event,
  ) {
    if (event.result != null) {
      A2ACLIClientSupport.commonPrintHandling(event.result!);
    } else {
      print('${Colorize('Null result returned by agent')..red()}');
    }
  }

  /// Print agent event
  static void printAgentEvent(A2ASendMessageSuccessResponse event) {
    if (event.result != null) {
      A2ACLIClientSupport.commonPrintHandling(event.result!);
    } else {
      print('${Colorize('Null result returned by agent')..red()}');
    }
  }

  /// Streaming event processor
  static void processAgentStreamingResponse(
    A2ASendStreamMessageResponse response,
  ) {
    // Check for error
    if (response.isError) {
      final error = response as A2AJSONRPCError;
      final code = error.code;
      print(
        '${Colorize('Streaming response from the agent is an RPC error, code is $code, '
        '${A2AError.asString(code)}')..red()}',
      );
      return;
    }

    // Process the response
    final event = response as A2ASendStreamMessageSuccessResponse;
    A2ACLIClientSupport.printAgentEventStreaming(event);
  }

  /// Single message processor
  static void processAgentResponse(A2ASendMessageResponse response) {
    // Check for an error
    if (response.isError) {
      final error = response as A2AJSONRPCErrorResponseS;
      final code = error.error?.rpcErrorCode;
      print(
        '${Colorize('Send message response from the agent is an RPC error, code is $code, '
        '${A2AError.asString(code!)}')..red()}',
      );
      return;
    }

    // Process the response
    final event = response as A2ASendMessageSuccessResponse;
    A2ACLIClientSupport.printAgentEvent(event);
  }

  /// Query the agent
  static Future<void> queryAgent(String query) async {
    // Construct the parameters
    final messageId =
        A2ACLIClientSupport.generateId(); // Generate a unique message ID

    // Parameters
    final part = A2ATextPart()..text = query;

    final messagePayload = A2AMessage()
      ..messageId = messageId
      ..role = 'user'
      ..parts = [part];

    // Conditionally add taskId to the message payload
    if (A2ACLIClientSupport.currentTaskId.isNotEmpty) {
      messagePayload.taskId = A2ACLIClientSupport.currentTaskId;
    }

    // Conditionally add contextId to the message payload
    if (A2ACLIClientSupport.currentContextId.isNotEmpty) {
      messagePayload.contextId = A2ACLIClientSupport.currentContextId;
    }

    final configuration = A2AMessageSendConfiguration()
      ..acceptedOutputModes = ['text']
      ..blocking = false
      ..acceptedOutputModes = ['text', 'text/plain', 'text/json'];

    final params = A2AMessageSendParams()
      ..message = messagePayload
      ..configuration = configuration;

    // Send the message, streaming if supported
    try {
      if (A2ACLIClientSupport.agentSupportsStreaming &&
          !A2ACLIClientSupport.noStreaming) {
        final events = A2ACLIClientSupport.client?.sendMessageStream(params);
        await for (final event in events!) {
          A2ACLIClientSupport.processAgentStreamingResponse(event);
        }
      } else {
        // Fallback to send message
        print(
          '${Colorize('Agent does not support streaming or streaming methods are disabled.')..blue()}',
        );
        params.configuration?.blocking = true;
        final response = await A2ACLIClientSupport.client?.sendMessage(params);
        if (response != null) {
          A2ACLIClientSupport.processAgentResponse(response);
        } else {
          print('${Colorize('Response from send message is null')..red()}');
        }
      }
    } catch (e) {
      print('Exception received in send message');
      rethrow;
    }
  }

  /// Resubscribe a task
  static Future<void> queryAgentResub() async {
    if (!A2ACLIClientSupport.agentSupportsStreaming ||
        A2ACLIClientSupport.noStreaming) {
      print(
        '${Colorize('Agent does not support streaming or streaming methods are disabled, cannot resubscribe')..yellow()}',
      );
      return;
    }

    if (A2ACLIClientSupport.currentTaskId.isEmpty) {
      print('${Colorize('No current task Id, cannot resubscribe')..yellow()}');
      return;
    }

    // Parameters
    final params = A2ATaskIdParams()..id = A2ACLIClientSupport.currentTaskId;

    // Resubscribe the task
    try {
      final events = A2ACLIClientSupport.client?.resubscribeTask(params);
      await for (final event in events!) {
        A2ACLIClientSupport.processAgentStreamingResponse(event);
      }
    } catch (e) {
      print('Exception received in resubscribe task');
      rethrow;
    }
  }
}
