# Quickshell.Services.Polkit - PolkitAgent
**Version:** v0.3.0
**Description:** An authentication agent for Polkit.
## Properties
* `isRegistered`: `bool` (readonly) - Indicates whether the agent registered successfully and is in use.
* `path`: `string` - The D-Bus path that this agent listener will use.
* `flow`: `AuthFlow` (readonly) - The current authentication state if an authentication request is active.
* `isActive`: `bool` (readonly) - Indicates an ongoing authentication request.
