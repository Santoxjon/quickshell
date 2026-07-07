# Quickshell.Services.Polkit - AuthFlow
**Version:** v0.3.0
**Description:** The state of an ongoing authentication request.
## Properties
* `iconName`: `string` (readonly) - The icon to present to the user in association with the message.
* `inputPrompt`: `string` (readonly) - This message is used to prompt the user for required input.
* `responseVisible`: `bool` (readonly) - Indicates whether the user’s response should be visible. (e.g. for passwords this should be false)
* `selectedIdentity`: `unknown` - The identity that will be used to authenticate.
* `supplementaryMessage`: `string` (readonly) - An additional message to present to the user.
* `cookie`: `string` (readonly) - A cookie that identifies this authentication request.
* `supplementaryIsError`: `bool` (readonly) - Indicates whether the supplementary message is an error.
* `isCompleted`: `bool` (readonly) - Has the authentication request been completed.
* `isSuccessful`: `bool` (readonly) - Indicates whether the authentication request was successful.
* `isCancelled`: `bool` (readonly) - Indicates whether the current authentication request was cancelled.
* `isResponseRequired`: `bool` (readonly) - Indicates that a response from the user is required from the user, typically a password.
* `identities`: `list` (readonly) - The list of identities that may be used to authenticate.
* `message`: `string` (readonly) - The main message to present to the user.
* `actionId`: `string` (readonly) - The action ID represents the action that is being authorized.
* `failed`: `bool` (readonly) - Indicates whether an authentication attempt has failed at least once during this authentication flow.
## Functions
* `cancelAuthenticationRequest()`: `void` - Cancel the ongoing authentication request from the user side.
* `submit(value)`: `void` - Submit a response to a request that was previously emitted. Typically the password.
