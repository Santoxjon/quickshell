# ShortcutInhibitor
**Version:** v0.3.0
**Description:** Prevents compositor keyboard shortcuts from being triggered

Using a shortcuts inhibitor requires the compositor support the keyboard-shortcuts-inhibit-unstable-v1 protocol.

## Properties
* `enabled`: bool - If the shortcuts inhibitor should be enabled. Defaults to false.
* `active`: bool - Whether the inhibitor is currently active. The inhibitor is only active if enabled is true, window has keyboard focus, and the compositor grants the inhibit request.
* `window`: QtObject - The window to associate the shortcuts inhibitor with. The inhibitor will only inhibit shortcuts pressed while this window has keyboard focus.

## Signals
* `cancelled()`: Sent if the compositor cancels the inhibitor while it is active.
