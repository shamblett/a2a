/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

library;

import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:http/http.dart' as http;

/// The client test server
class A2ATestClientServer {
  /// Port
  int port = 8080;

  /// The server
  late HttpServer server;

  // Router instance to handler requests.
  late shelf_router.Router router;

  int requestCount = 0;

  String dartVersion = '<Not Set>';

  A2ATestClientServer();

  /// Start the server
  Future<A2ATestClientServer> start() async {
    router = shelf_router.Router()
      ..get('/helloworld', _helloWorldHandler)
      ..get('/info.json', _infoHandler);
    final cascade = Cascade().add(router.call);
    dartVersion = _setDartVersion();
    server = await shelf_io.serve(
      // See https://pub.dev/documentation/shelf/latest/shelf/logRequests.html
      logRequests()
      // See https://pub.dev/documentation/shelf/latest/shelf/MiddlewareExtensions/addHandler.html
      .addHandler(cascade.handler),
      InternetAddress.loopbackIPv4, // Allows external connections
      port,
    );

    print(
      'A2ATestServer:: Serving at http://${server.address.host}:${server.port}',
    );

    return this;
  }

  void stop() => server.close(force: true);

  Response _helloWorldHandler(Request request) => Response.ok('Hello, World!');

  String _setDartVersion() {
    final version = Platform.version;
    return version.substring(0, version.indexOf(' '));
  }

  String _jsonEncode(Object? data) =>
      const JsonEncoder.withIndent(' ').convert(data);

  final _jsonHeaders = {'content-type': 'application/json'};

  Response _infoHandler(Request request) => Response(
    200,
    headers: {..._jsonHeaders, 'Cache-Control': 'no-store'},
    body: _jsonEncode({
      'Dart version': dartVersion,
      'requestCount': ++requestCount,
    }),
  );
}

class Utilities {
  /// Check the server is running, returns false if not
  static FutureOr<bool> checkServer() async {
    bool ret = true;
    final checkPath = Uri(
      scheme: 'http',
      host: 'localhost',
      port: 8080,
      path: 'helloworld',
    );
    final response = await http.get(checkPath);
    if (response.statusCode != 200) {
      print('Client Test:: status code error, value is ${response.statusCode}');
      ret = false;
    }
    if (response.body != 'Hello, World!') {
      print('Client Test:: hell world failed, body is ${response.body}');
      ret = false;
    }

    return ret;
  }
}
