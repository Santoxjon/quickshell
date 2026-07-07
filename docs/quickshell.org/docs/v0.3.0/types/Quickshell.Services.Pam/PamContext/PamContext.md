# PamContext

**Version:** v0.3.0

**Description:**
Connection to pam.

## Properties
* `active`: bool - If the pam context is actively performing an authentication.
* `user`: string - The user to authenticate as. If unset the current user will be used.
* `message`: string (readonly) - The last message sent by pam.
* `configDirectory`: string - The pam configuration directory to use. Defaults to “/etc/pam.d”.
* `messageIsError`: bool (readonly) - If the last message should be shown as an error.
* `responseVisible`: bool (readonly) - If the user’s response should be visible. Only valid when responseRequired is true.
* `config`: string - The pam configuration to use. Defaults to “login”.
* `responseRequired`: bool (readonly) - If pam currently wants a response.

## Functions
* `abort()`: void - Abort a running authentication session.
* `respond(response)`: void - Respond to pam.
* `start()`: bool - Start an authentication session. Returns if the session was started successfully.

## Signals
* `completed(result)` - Emitted whenever authentication completes.
* `pamMessage()` - Emitted whenever pam sends a new message, after the change signals for message, messageIsError, and responseRequired.
* `error(error)` - Emitted if pam fails to perform authentication normally.
