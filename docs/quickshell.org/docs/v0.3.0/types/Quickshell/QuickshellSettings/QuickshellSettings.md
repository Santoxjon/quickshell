# QuickshellSettings

**Inherits:** [QObject](https://doc.qt.io/qt-6/qobject.html)

Accessor for some options under the Quickshell type.

## Properties

- `workingDirectory` : `string` - Quickshell’s working directory. Defaults to whereever quickshell was launched from.
- `watchFiles` : `bool` - If true then the configuration will be reloaded whenever any files change. Defaults to true.

## Signals

- `lastWindowClosed()` - Sent when the last window is closed.
