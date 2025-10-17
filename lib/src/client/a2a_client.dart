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
import 'package:oxy/oxy.dart' as http;
import 'package:uuid/uuid.dart';

part 'src/a2a_client.dart';
part 'src/a2a_authentication_handler.dart';
part 'src/a2a_cli_client_support.dart';
