# Toplevel
**Version:** v0.3.0
**Description:** Window from another application.

A Toplevel can be used to interact with windows from other applications. Toplevels are created by the ToplevelManager.

## Properties
* `maximized`: bool - If the window is currently maximized.
* `activated`: bool - If the window is currently activated or focused.
* `appId`: string - The application ID of the toplevel.
* `fullscreen`: bool - If the window is currently fullscreen.
* `minimized`: bool - If the window is currently minimized.
* `screens`: list<ShellScreen> - Screens the toplevel is currently visible on.
* `title`: string - The title of the toplevel.
* `parent`: Toplevel - Parent toplevel if this toplevel is a modal/dialog, otherwise null.

## Functions
* `activate()`: Request that this toplevel is activated.
* `close()`: Request that this toplevel is closed.
* `fullscreenOn(screen)`: Request that this toplevel is fullscreened on a specific screen.
* `setRectangle(window, rect)`: Provide a hint to the compositor where the visual representation of this toplevel is relative to a quickshell window.
* `unsetRectangle()`: Unset the rectangle hint.

## Signals
* `closed()`: Sent when the toplevel is closed.
