
Perform the following steps before releasing a new version of the package

Test the a2a_cli_client(package version, NOT the installed version) against

* The remote client
* The local agent example
* The local agent helloworld example
* The local agent podman helloworld example

Along with the unit tests the following manual tests should be run :-

* a2a_client_example_agent
* a2a_client_local against the local server agent helloworld example
* a2a_client_local against the podman helloworld example
* a2a_client_remote, expect failures here.
