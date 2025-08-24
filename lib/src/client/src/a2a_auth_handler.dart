/*
* Package : a2a
* Author : S. Hamblett <steve.hamblett@linux.com>
* Date   : 10/07/2025
* Copyright :  S.Hamblett
*/

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
interface class A2AAuthenticationHandler {