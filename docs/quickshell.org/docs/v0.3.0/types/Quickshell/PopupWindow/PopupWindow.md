# PopupWindow

**Inherits**: `FloatingWindow`

Popup window.

This is a popup window that can be anchored to another item or window. It is a specialized `FloatingWindow` that is designed to be used for popups.

## Properties

-   **screen**: `ShellScreen` (readonly)
    The screen that the window currently occupies.

-   **visible**: `bool`
    If the window is shown or hidden. Defaults to false.

-   **relativeY**: `int`
    Deprecated in favor of `anchor.rect.y`.

-   **anchor**: `PopupAnchor` (readonly)
    The popup’s anchor / positioner relative to another item or window.

-   **parentWindow**: `QtObject`
    Deprecated in favor of `anchor.window`.

-   **relativeX**: `int`
    Deprecated in favor of `anchor.rect.x`.

-   **grabFocus**: `bool`
    If true, the popup window will be dismissed and `visible` will change to false if the user clicks outside of the popup or it is otherwise closed.
