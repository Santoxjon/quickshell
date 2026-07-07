# Quickshell.Wayland - IdleMonitor
**Version:** v0.3.0
**Description:** Provides a notification when a wayland session is makred idle

An idle monitor provides a notification when a wayland session is marked idle, for example due to a lack of user input.

> **NOTE**
> Using an idle monitor requires the compositor support the ext-idle-notify-v1 protocol.

## Properties
* `isIdle`: `bool` (readonly) - This property is true if the user has been idle for at least `timeout`. What is considered to be idle is influenced by `respectInhibitors`.
* `enabled`: `bool` - If the idle monitor should be enabled. Defaults to true.
* `timeout`: `real` - The amount of time in seconds the idle monitor should wait before reporting an idle state. Defaults to zero, which reports idle status immediately.
* `respectInhibitors`: `bool` - When set to true, `isIdle` will depend on both user interaction and active idle inhibitors. When false, the value will depend solely on user interaction. Defaults to true.
