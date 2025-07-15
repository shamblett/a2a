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

/// The test server class
class A2ATestServer {
  /// Port
  int port = 8080;

  /// The server
  late HttpServer server;

  /// Cascade routing
  final cascade = Cascade();

  // Router instance to handler requests.
  late shelf_router.Router router;

  int requestCount = 0;

  String dartVersion = '<Not Set>';

  A2ATestServer();

  /// Start the server
  Future<A2ATestServer> start() async {
    cascade.add(router.call);
    dartVersion = _setDartVersion();
    router = shelf_router.Router()
      ..get('/helloworld', _helloWorldHandler)
      ..get('/info.json', _infoHandler);
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
