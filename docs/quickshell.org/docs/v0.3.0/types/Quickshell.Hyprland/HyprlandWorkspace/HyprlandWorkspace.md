# HyprlandWorkspace

**Inherits:** [QtObject](https://doc.qt.io/qt-6/qobject.html)

## Properties

- **active**: *bool* `readonly` - If this workspace is currently active on its monitor.
- **hasFullscreen**: *bool* `readonly` - If this workspace currently has a fullscreen client.
- **focused**: *bool* `readonly` - If this workspace is currently active on a monitor and that monitor is currently focused.
- **id**: *int* `readonly`
- **urgent**: *bool* `readonly` - If this workspace has a window that is urgent.
- **monitor**: *HyprlandMonitor* `readonly`
- **name**: *string* `readonly`
- **lastIpcObject**: *unknown* `readonly` - Last json returned for this workspace, as a javascript object.
- **toplevels**: *ObjectModel* `readonly` - List of toplevels on this workspace.

## Functions

- **activate()**: *void* - Activate the workspace.
