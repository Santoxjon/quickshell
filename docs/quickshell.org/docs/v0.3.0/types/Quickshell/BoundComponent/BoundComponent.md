# BoundComponent

**Inherits**: `Item`

Component loader that allows setting initial properties. This is useful for creating components that can be configured from the outside, without creating cyclic dependency errors.

Properties defined on the BoundComponent will be applied to its loaded component, including required properties, and will remain reactive. Functions created with the names of signal handlers will also be attached to signals of the loaded component.

## Properties

-   **item**: `QtObject` (readonly)
    The loaded component. Will be null until it has finished loading.

-   **bindValues**: `bool`
    If property values should be bound after they are initially set. Defaults to `true`.

-   **source**: `string`
    The source to load, as a Url.

-   **implicitHeight**: `real` (readonly)

-   **sourceComponent**: `Component`
    The source to load, as a Component.

-   **implicitWidth**: `real` (readonly)

## Example

MyComponent.qml:
```qml
MouseArea {
  required property color color;
  width: 100
  height: 100

  Rectangle {
    anchors.fill: parent
    color: parent.color
  }
}
```

Usage:
```qml
BoundComponent {
  source: "MyComponent.qml"

  // this is the same as assigning to `color` on MyComponent if loaded normally.
  property color color: "red";

  // this will be triggered when the `clicked` signal from the MouseArea is sent.
  function onClicked() {
    color = "blue";
  }
}
```
