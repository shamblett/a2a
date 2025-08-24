/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

part of '../a2a_client.dart';

/// Generic interface for handling authentication for HTTP requests.
///
/// - For each HTTP request, this handler is called to provide additional headers to the request through
///   the headers() function.
/// - After the server returns a response, the shouldRetryWithHeaders() function is called.  Usually this
///   function responds to a 401 or 403 response or JSON-RPC codes, but can respond to any other signal -
///   that is an implementation detail of the AuthenticationHandler.
/// - If the shouldRetryWithHeaders() function returns new headers, then the request should retried with the provided
///   revised headers.  These provisional headers may, or may not, be optimistically stored for subsequent requests -
///   that is an implementation detail of the AuthenticationHandler.
/// - If the request is successful and the onSuccessfulRetry() is defined, then the onSuccessfulRetry() function is
///   called with the headers that were used to successfully complete the request.  This callback provides an
///   opportunity to save the headers for subsequent requests if they were not already saved.
///
abstract interface class A2AAuthenticationHandler {
  /// Provides additional HTTP request headers.
  /// @returns HTTP headers which may include Authorization if available.
  Future<http.Headers> get headers;

  /// For every HTTP response (even 200s) the shouldRetryWithHeaders() method is called.
  /// This method is supposed to check if the request needs to be retried and if, yes,
  /// return a set of headers. An A2A server might indicate auth failures in its response
  /// by JSON-rpc codes, HTTP codes like 401, 403 or headers like WWW-Authenticate.
  ///
  /// @param req The RequestInit object used to invoke fetch()
  /// @param res The fetch Response object
  /// @returns If the HTTP request should be retried then returns the HTTP headers to use,
  /// 	or returns undefined if no retry should be made.
  Future<http.Headers> shouldRetryWithHeaders(
    http.Request req,
    http.Response res,
  );

  /// If the last HTTP request using the headers from [shouldRetryWithHeaders] was successful, and
  /// this function is implemented, then it will be called with the headers provided from
  /// [shouldRetryWithHeaders].
  ///
  /// This callback allows transient headers to be saved for subsequent requests only when they
  /// are validated by the server.
  Future<void>? onSuccessfulRetry(http.Headers headers);
}
