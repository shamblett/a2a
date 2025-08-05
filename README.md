# a2a

This package provides an SDK for the Agent 2 Agent(A2A) protocol which provides 
an open protocol enabling communication and interoperability between opaque agentic 
applications. Please see [here](https://github.com/a2aproject/A2A) for the A2A project overview.
This package assumes some familiarity with the A2A project in terms of goals, terminology etc.

Specifically the project implements an A2A SDK for Dart, modelled from the JavaScript
SDK that can be found [here](https://github.com/a2aproject/a2a-js).

The roadmap for the package is that the initial release contains the A2AClient, to be followed by 
implementation of the cli-client, the server functionality and a sample agent. 

The SDK consists of the following components :-

## The A2A Client

The A2A client(A2AClient) provides the client API for an agent. This allows users to send messages, streaming messages
using SSE responses, fetching of an agents agent card and other management functions such as
agent configuration and task resubscription.

##### Key Features :-

* JSON-RPC Communication: Handles sending requests and receiving responses (both standard and streaming via Server-Sent Events) according to the JSON-RPC 2.0 specification.


* A2A Methods: Implements standard A2A methods like sendMessage, sendMessageStream, getTask, cancelTask, setTaskPushNotificationConfig, getTaskPushNotificationConfig, and resubscribeTask.


* Error Handling: Provides basic error handling for network issues and JSON-RPC errors.


* Streaming Support: Manages Server-Sent Events (SSE) for real-time task updates (sendMessageStream, resubscribeTask).

An example using the A2AClient to communicate with a test agent can be found in the examples directory, 
[here](https://github.com/shamblett/a2a/blob/main/example/a2a_client.dart).

## The A2A CLI Client

The A2A CLI client(a2a_cli_client) provides a simple CLI client for interacting with an agent.
The client supports fetching and display of an agents agent card, querying of an agent using normal send message
or streaming requests if streaming is supported.

Responses are handled and displayed to the user to allow visibility of the request/response
interplay between the client and the agent for a particular request.

The client supports the following commands that can be entered at the prompt :-

* /exit - exits the client.
* /new - starts a new session by clearing any current task and context information.
* /resub - attempts to resubscribe an already started task if the SSE event stream for a previous task has been broken.

THh client is installed in the usual manner i.e. 
```
dart pub global activate a2a
```
This will give you command line access to the a2a_cli_client.

## The A2A Server

_Not yet implemented - will be in a subsequent version_

## Sample agent

_Not yet implemented - will be in a subsequent version_

Several sample agents implemented in various languages can be found [here](https://github.com/a2aproject/a2a-samples)