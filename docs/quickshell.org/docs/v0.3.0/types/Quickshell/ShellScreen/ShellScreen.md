# ShellScreen
**Inherits:** [QObject](https://doc.qt.io/qt-6/qobject.html)

Represents a single monitor, for showing windows on it or querying information about the monitor.

> [!WARNING]
> If the monitor is disconnected, then any stored copies of its ShellMonitor will be marked as dangling and all properties will return default values. Reconnecting the monitor will not reconnect it to the ShellMonitor object.

Due to some technical limitations, it was not possible to reuse the native qml [Screen](https://doc.qt.io/qt-6/qml-qtquick-screen.html) type.

## Properties
### y
**Type:** [int](https://doc.qt.io/qt-6/qml-int.html) `readonly`

*No details provided*

### logicalPixelDensity
**Type:** [real](https://doc.qt.io/qt-6/qml-real.html) `readonly`

The number of device-independent (scaled) pixels per millimeter.

### height
**Type:** [int](https://doc.qt.io/qt-6/qml-int.html) `readonly`

*No details provided*

### width
**Type:** [int](https://doc.qt.io/qt-6/qml-int.html) `readonly`

*No details provided*

### x
**Type:** [int](https://doc.qt.io/qt-6/qml-int.html) `readonly`

*No details provided*

### model
**Type:** [string](https://doc.qt.io/qt-6/qml-string.html) `readonly`

The model of the screen as seen by the operating system.

### serialNumber
**Type:** [string](https://doc.qt.io/qt-6/qml-string.html) `readonly`

The serial number of the screen as seen by the operating system.

### orientation
**Type:** unknown `readonly`

*No details provided*

### devicePixelRatio
**Type:** [real](https://doc.qt.io/qt-6/qml-real.html) `readonly`

The ratio between physical pixels and device-independent (scaled) pixels.

### name
**Type:** [string](https://doc.qt.io/qt-6/qml-string.html) `readonly`

The name of the screen as seen by the operating system.

Usually something like `DP-1`, `HDMI-1`, `eDP-1`.

### physicalPixelDensity
**Type:** [real](https://doc.qt.io/qt-6/qml-real.html) `readonly`

The number of physical pixels per millimeter.

### primaryOrientation
**Type:** unknown `readonly`

*No details provided*

## Functions
### toString()
**Returns:** [string](https://doc.qt.io/qt-6/qml-string.html)

*No details provided*
