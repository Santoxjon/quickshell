# HyprlandWindow

**Inherits:** [QsWindow](../../Quickshell/QsWindow/QsWindow.md)

## Description

Hyprland specific `QsWindow` properties.

This type is an attached object, and can be attached to any `QsWindow` or derivative type, such as `PanelWindow` or `PopupWindow`.

### Example

```qml
PopupWindow {
  // ...
  HyprlandWindow.opacity: 0.6 // any number or binding
}
```

> **Note**
> Requires at least Hyprland 0.47.0, or `hyprland-surface-v1` support.

## Properties

| Type | Name | Description |
|------|------|-------------|
| `real` | `opacity` | A multiplier for the window's overall opacity, ranging from **1.0** to **0.0**. Overall opacity includes the opacity of both the window content *and* visual effects such as blur that apply to it. **Default:** `1.0`. |
| [Region](../../Quickshell/Region/Region.md) | `visibleMask` | A hint to the compositor that only certain regions of the surface should be rendered. This can be used to avoid rendering large empty regions of a window, which can improve performance, especially if the window is blurred. The mask should include all pixels of the window that do not have an alpha value of `0`. |