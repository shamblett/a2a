/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:colorize/colorize.dart';
import 'package:mcp_dart/mcp_dart.dart';
import 'package:uuid/uuid.dart';

import '../client/a2a_client.dart';
import '../types/a2a_types.dart';

part 'src/a2a_mcp_server.dart';
part 'src/a2a_mcp_bridge.dart';
