# PersistentProperties

**Inherits**: `Reloadable`

Object that holds properties that can persist across a config reload.

This object is useful for keeping state across reloads. For example, if you have a popup that you want to keep open after a reload, you can use a `PersistentProperties` object to store the open state.

## Example

The following snippet creates a `PersistentProperties` object with a `expanderOpen` property. This property is used to control the visibility of a `Rectangle`. When the `Button` is clicked, the `expanderOpen` property is toggled, and the `Rectangle` is shown or hidden. When the configuration is reloaded, the `expanderOpen` property will be saved and the expandable panel will stay in the open/closed state.

```qml
PersistentProperties {
  id: persist
  reloadableId: "persistedStates"

  property bool expanderOpen: false
}

Button {
  id: expanderButton
  anchors.centerIn: parent
  text: "toggle expander"
  onClicked: persist.expanderOpen = !persist.expanderOpen
}

Rectangle {
  anchors.top: expanderButton.bottom
  anchors.left: expanderButton.left
  anchors.right: expanderButton.right
  height: 100

  color: "lightblue"
  visible: persist.expanderOpen
}
```

## Signals

- **reloaded()**
  Called every time the properties are reloaded. Will not be called if no old instance was loaded.

- **loaded()**
  Called every time the reload stage completes. Will be called every time, including when nothing was loaded from an old instance.
