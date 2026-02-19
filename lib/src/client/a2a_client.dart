/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

library;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:a2a/a2a.dart';
import 'package:colorize/colorize.dart';
import 'package:genai_primitives/genai_primitives.dart';
import 'package:oxy/oxy.dart' as http;
import 'package:uuid/uuid.dart';

import 'src/a2a_genai_primitives_mapper.dart';

part 'src/a2a_client.dart';
part 'src/a2a_authentication_handler.dart';
part 'src/a2a_cli_client_support.dart';
