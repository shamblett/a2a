/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

library;

import 'dart:io';
import 'dart:async';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef RpcHandler = void Function(HttpRequest request);

/// The client RPC test server
class A2ATestRPCServer {

  /// The server
  late HttpServer httpServer;

  A2ATestRPCServer();

  Future<void> start(RpcHandler handler) async {
    httpServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 8081);
    var connectedChannels = httpServer;
    connectedChannels.listen(handler);
  }

  void stop() {
    httpServer.close(force: true);
  }
}
