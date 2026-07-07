# HyprlandToplevel

**Inherits:** [QtObject](https://doc.qt.io/qt-6/qobject.html)

## Description

Represents a toplevel window in Hyprland.

Can also be used as an attached object of a `Toplevel`, to resolve a handle to an Hyprland toplevel.

## Properties

| Type                                               | Name            | Description                                                                                                                                                                                          |
| -------------------------------------------------- | --------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| string                                             | `title`         | `readonly` The title of the toplevel                                                                                                                                                                 |
| [HyprlandMonitor](../HyprlandMonitor/HyprlandMonitor.md)     | `monitor`       | `readonly` The current monitor of the toplevel (might be null)                                                                                                                                       |
| string                                             | `address`       | `readonly` Hexadecimal Hyprland window address. Will be an empty string until the address is reported.                                                                                               |
| [Toplevel](../../Quickshell.Wayland/Toplevel/Toplevel.md) | `wayland`       | `readonly` The wayland toplevel handle. Will be null intil the address is reported                                                                                                                   |
| [HyprlandWorkspace](../HyprlandWorkspace/HyprlandWorkspace.md) | `workspace`     | `readonly` The current workspace of the toplevel (might be null)                                                                                                                                     |
| unknown                                            | `lastIpcObject` | `readonly` Last json returned for this toplevel, as a javascript object. This is *not* updated unless the toplevel object is fetched again from Hyprland. If you need a value that is subject to change and does not have a dedicated property, run `Hyprland.refreshToplevels()` and wait for this property to update. |
| bool                                               | `activated`     | `readonly` Whether the toplevel is active or not                                                                                                                                                     |
| bool                                               | `urgent`        | `readonly` Whether the client is urgent or not                                                                                                                                                       |
| [HyprlandToplevel](HyprlandToplevel.md)                       | `handle`        | `readonly` The toplevel handle, exposing the Hyprland toplevel. Will be null until the address is reported                                                                                             |
