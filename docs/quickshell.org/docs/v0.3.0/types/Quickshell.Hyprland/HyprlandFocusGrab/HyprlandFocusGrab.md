---
title: HyprlandFocusGrab
---

# HyprlandFocusGrab

**Inherits:** [QtObject](https://doc.qt.io/qt-6/qml-qtqml-qtobject.html)

## Description

Input focus grabber.

This type provides a way to grab input focus for a set of windows. It uses the `ext_transient_input` wayland protocol.

When enabled, all of the windows listed in the `windows` property will receive input normally, and will retain keyboard focus even if the mouse is moved off of them. When areas of the screen that are not part of a listed window are clicked or touched, the grab will become inactive and emit the cleared signal.

This is useful for implementing dismissal of popup type windows.

```qml
import Quickshell
import Quickshell.Hyprland
import QtQuick.Controls

ShellRoot {
  FloatingWindow {
    id: window

    Button {
      anchors.centerIn: parent
      text: grab.active ? "Remove exclusive focus" : "Take exclusive focus"
      onClicked: grab.active = !grab.active
    }

    HyprlandFocusGrab {
      id: grab
      windows: [ window ]
    }
  }
}
```

## Properties

| Type | Name | Description |
| --- | --- | --- |
| [bool](https://doc.qt.io/qt-6/qml-bool.html) | `active` | If the focus grab is active. Defaults to false. When set to true, an input grab will be created for the listed windows. This property will change to false once the grab is dismissed. It will not change to true until the grab begins, which requires at least one visible window. |
| [list](https://doc.qt.io/qt-6/qml-list.html)&lt;[QtObject](https://doc.qt.io/qt-6/qml-qtqml-qtobject.html)&gt; | `windows` | The list of windows to whitelist for input. |

## Signals

| Name | Description |
| --- | --- |
| `cleared()` | Sent whenever the compositor clears the focus grab. This may be in response to all windows being removed from the list or simultaneously hidden, in addition to a normal clear. |
