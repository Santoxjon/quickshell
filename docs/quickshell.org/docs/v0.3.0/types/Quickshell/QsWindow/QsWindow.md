# QsWindow

Inherits: [Window](https://doc.qt.io/qt-6/qml-qtquick-window.html)

Base class of Quickshell windows

## Attached properties

`QSWindow` can be used as an attached object of anything that subclasses [Item](https://doc.qt.io/qt-6/qml-qtquick-item.html).
It provides the following properties

- `window` - the `QSWindow` object.
- `contentItem` - the `contentItem` property of the window.

**itemPosition**, **itemRect**, and **mapFromItem** can also be called directly
on the attached object.

## Properties

- `backingWindowVisible` : `bool` - If the window is currently shown. You should generally prefer [visible](#prop.visible).
- `height` : `int` - The window’s actual height.
- `implicitWidth` : `int` - The window’s desired width.
- `devicePixelRatio` : `real` - The ratio between logical pixels and monitor pixels.
- `implicitHeight` : `int` - The window’s desired height.
- `width` : `int` - The window’s actual width.
- `color` : `color` - The background color of the window. Defaults to white.
- `screen` : `ShellScreen` - The screen that the window currently occupies.
- `visible` : `bool` - If the window should be shown or hidden. Defaults to true.
- `surfaceFormat` : `[opaque]` - Set the surface format to request from the system.
- `updatesEnabled` : `bool` - If the window should receive render updates. Defaults to true.
- `contentItem` : `Item` - (readonly)
- `mask` : `Region` - The clickthrough mask. Defaults to null.
- `windowTransform` : `QtObject` - (readonly) Opaque property that will receive an update when factors that affect the window’s position and transform changed.
- `data` : `list<QtObject>` - (default, readonly)

## Functions

- `itemPosition(item)` : `point` - Returns the given Item’s position relative to the window. Does not update reactively.
- `itemRect(item)` : `rect` - Returns the given Item’s geometry relative to the window. Does not update reactively.
- `mapFromItem(item, point)` : `point` - Maps the given point in the coordinate space of item to the coordinate space of this window. Does not update reactively.
- `mapFromItem(item, x, y)` : `point` - Maps the given point (x, y) in the coordinate space of item to the coordinate space of this window. Does not update reactively.
- `mapFromItem(item, rect)` : `rect` - Maps the given rect in the coordinate space of item to the coordinate space of this window. Does not update reactively.
- `mapFromItem(item, x, y, width, height)` : `rect` - Maps the given rect (x, y, width, height) in the coordinate space of item to the coordinate space of this window. Does not update reactively.

## Signals

- `windowConnected()`
- `resourcesLost()` - This signal is emitted when resources a window depends on to display are lost, or could not be acquired during window creation.
- `closed()` - This signal is emitted when the window is closed by the user, the display server, or an error.
