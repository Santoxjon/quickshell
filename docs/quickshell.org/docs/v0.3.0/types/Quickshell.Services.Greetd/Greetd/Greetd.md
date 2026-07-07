# Greetd

**Version:** v0.3.0

**Description:**
A singleton for interacting with the greetd daemon. With it you can authenticate a user and launch a session.

## Properties
*   `available`: bool - If the greetd socket is available.
*   `user`: string - The currently authenticating user.
*   `state`: GreetdState - The current state of the greetd connection.

## Functions
*   `cancelSession()`: void - Cancel the active greetd session.
*   `createSession(user)`: void - Create a greetd session for the given user.
*   `launch(command)`: void - Launch the session, exiting quickshell.
*   `launch(command, environment)`: void - Launch the session, exiting quickshell.
*   `launch(command, environment, quit)`: void - Launch the session.
*   `respond(response)`: void - Respond to an authentication message.

## Signals
*   `authFailure(message)` - Authentication has failed an the session has terminated.
*   `authMessage(message, error, responseRequired, echoResponse)` - An authentication message has been received.
*   `launched()` - Greetd has acknowledged the launch request and the greeter should quit as soon as possible.
*   `error(error)` - Greetd has encountered an error.
*   `readyToLaunch()` - Authentication has finished successfully and greetd can now launch a session.
