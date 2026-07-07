# PanelWindow

**Inherits**: `QsWindow`

Decorationless window attached to screen edges by anchors.

## Example

The following snippet creates a white bar attached to the bottom of the screen.

```qml
PanelWindow {
  anchors {
    left: true
    bottom: true
    right: true
  }

  Text {
    anchors.centerIn: parent
    text: "Hello!"
  }
}
```

## Properties

- **exclusiveZone**: `int`
  The amount of space reserved for the shell layer relative to its anchors. Setting this property sets `exclusionMode` to `ExclusionMode.Normal`.
  **Note**: Either 1 or 3 anchors are required for the zone to take effect.

- **aboveWindows**: `bool`
  If the panel should render above standard windows. Defaults to true.
  **Note**: On Wayland this property corresponds to `WlrLayershell.layer`.

- **exclusionMode**: `ExclusionMode`
  Defaults to `ExclusionMode.Auto`.

- **anchors**: `[bottom, left, right, top]`
  The screen edges that the panel should be attached to.
  - `bottom`: `bool`
  - `left`: `bool`
  - `right`: `bool`
  - `top`: `bool`
  By default all anchors are disabled to avoid blocking the entire screen due to a misconfiguration.
  **Note**: When two opposite anchors are attached at the same time, the corresponding dimension (width or height) will be forced to equal the screen width/height. Margins can be used to create anchored windows that are also disconnected from the monitor sides.

- **focusable**: `bool`
  If the panel should accept keyboard focus. Defaults to false.
  **Note**: On Wayland this property corresponds to `WlrLayershell.keyboardFocus`.

- **margins**: `[right, top, bottom, left]`
  The margins of the panel relative to the screen edges.
  - `right`: `int`
  - `top`: `int`
  - `bottom`: `int`
  - `left`: `int`
  **Note**: Only applies to edges with anchors.
