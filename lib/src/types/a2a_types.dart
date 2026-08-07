/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

library;

import 'package:colorize/colorize.dart';
import 'package:json_annotation/json_annotation.dart';

part 'src/a2a_common.dart';
part 'src/a2a_error.dart';
part 'src/a2a_security_scheme.dart';
part 'src/a2a_agent_card.dart';
part 'src/protocol_objects/a2a_task.dart';
part 'src/protocol_objects/a2a_message.dart';
part 'src/protocol_objects/a2a_artifact.dart';
part 'src/protocol_objects/a2a_push_notification_config.dart';
part 'src/json_rpc/a2a_json_rpc_request.dart';
part 'src/json_rpc/a2a_json_rpc_response.dart';
part 'src/json_rpc/a2a_json_rpc_error.dart';
part 'src/rpc_methods/request/a2a_request.dart';
part 'src/protocol_objects/a2a_part.dart';
part 'src/rpc_methods/response/a2a_cancel_task_response.dart';
part 'src/rpc_methods/response/a2a_get_task_push_notification_config_response.dart';
part 'src/rpc_methods/response/a2a_set_task_push_notification_config_response.dart';
part 'src/rpc_methods/response/a2a_list_task_push_notification_config_response.dart';
part 'src/rpc_methods/response/a2a_delete_task_push_notification_config_response.dart';
part 'src/rpc_methods/response/a2a_get_task_response.dart';
part 'src/rpc_methods/response/a2a_send_stream_message_response.dart';
part 'src/rpc_methods/request/a2a_send_message_request.dart';
part 'src/rpc_methods/request/a2a_send_streaming_message_request.dart';
part 'src/rpc_methods/request/a2a_get_task_request.dart';
part 'src/rpc_methods/request/a2a_cancel_task_request.dart';
part 'src/rpc_methods/request/a2a_set_task_push_notification_config_request.dart';
part 'src/rpc_methods/request/a2a_get_task_push_notification_config_request.dart';
part 'src/rpc_methods/request/a2a_list_task_push_notification_config_request.dart';
part 'src/rpc_methods/request/a2a_delete_task_push_notification_config_request.dart';
part 'src/rpc_methods/request/a2a_task_resubscription_request.dart';

/// JSON
part 'a2a_types.g.dart';
