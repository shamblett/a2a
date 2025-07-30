# a2a

This package provides an SDK for the Agent 2 Agent(A2A) protocol which provides 
an open protocol enabling communication and interoperability between opaque agentic 
applications. Please see [here](https://github.com/a2aproject/A2A) for the A2A project overview.
This package assumes some familiarity with the A2A project in terms of goals, terminology etc.

Specifically the project implements an A2A SDK for Dart, modelled from the JavaScript
SDK that can be found [here](https://github.com/a2aproject/a2a-js).

The roadmap for the package is that the initial release contains the A2AClient, to be followed by 
implementation of the cli-client and the server functionality. 

An example using the A2AClient to communicate with a test agent can be found in the examples directory, 
[here](https://github.com/shamblett/a2a/blob/main/example/a2a_client.dart).

Several sample agents implemented in various languages can be found [here](https://github.com/a2aproject/a2a-samples)