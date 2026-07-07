# PamError

**Version:** v0.3.0

**Description:**
An error that occurred during an authentication.

## Functions
* `toString(value)`: string

## Variants
* `InternalError` - An error occurred inside quickshell’s pam interface.
* `TryAuthFailed` - Failed to try to authenticate the user. This is not the same as the user failing to authenticate.
* `StartFailed` - Failed to start the pam session.
