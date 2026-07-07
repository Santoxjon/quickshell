# WlrLayershell
**Version:** v0.3.0
**Description:** Wlroots layershell window

## Properties
* `layer`: `WlrLayer` - The shell layer the window sits in. Defaults to `WlrLayer.Top`.
* `namespace`: `string` - Similar to the class property of windows. Can be used to identify the window to external tools. Cannot be set after windowConnected.
* `keyboardFocus`: `WlrKeyboardFocus` - The degree of keyboard focus taken. Defaults to `KeyboardFocus.None`.

## Attached object
`WlrLayershell` works as an attached object of `PanelWindow` which you should use instead if you can, as it is platform independent.
```qml
PanelWindow {
  // When PanelWindow is backed with WlrLayershell this will work
  WlrLayershell.layer: WlrLayer.Bottom
}
```

To maintain platform compatibility you can dynamically set layershell specific properties.
```qml
PanelWindow {
  Component.onCompleted: {
    if (this.WlrLayershell != null) {
      this.WlrLayershell.layer = WlrLayer.Bottom;
    }
  }
}
```
