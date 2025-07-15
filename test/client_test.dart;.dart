/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

library;

import 'dart:io';

import 'package:test/test.dart';
import 'package:http/http.dart';

import 'package:a2a/a2a.dart';

import 'support/server.dart';

Future<int> main() async {
  /// Start the test server
  final server = await A2ATestServer().start();

  /// Check it
  final checkPath = Uri(
    scheme: 'http',
    host: 'localhost',
    port: 8080,
    path: 'localhost/helloworld',
  );
  final response = await get(checkPath);
  if (response.statusCode != 200) {
    print('Client Test:: status code error, value is ${response.statusCode}');
    server.stop();
    exit(-1);
  }
  if (response.body != 'helloworld') {
    print('Client Test:: hell world failed, body is ${response.body}');
    server.stop();
    exit(-1);
  }

  print('Client Test:: waiting.....');
  await Future.delayed(Duration(seconds: 5));

  print('Client Test:: exiting.....');
  server.stop();

  return 0;
}
