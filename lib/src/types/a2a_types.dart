/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

library;

import 'package:json_annotation/json_annotation.dart';

part 'src/a2a_type.dart';
part 'src/area/a2a_error.dart';
part 'src/area/a2a_request.dart';
part 'src/area/a2a_part.dart';
part 'src/area/a2a_security_scheme.dart';
part 'src/area/a2a_cancel_task_response.dart';
part 'src/area/a2a_get_task_push_notification_config_response.dart';
part 'src/area/a2a_set_task_push_notification_config_response.dart';
part 'src/area/a2a_get_task_response.dart';
part 'src/area/a2a_json_rpc_response.dart';
part 'src/area/a2a_send_message_response.dart';
part 'src/area/a2a_send_stream_message_response.dart';
part 'src/area/a2a_agent.dart';

/// JSON
part 'a2a_types.g.dart';