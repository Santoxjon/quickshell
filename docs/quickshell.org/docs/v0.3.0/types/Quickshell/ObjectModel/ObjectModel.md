# ObjectModel

**Inherits**: `QtObject`

View into a list of objets.

An ObjectModel works as a QML Data Model, allowing efficient interaction with components that act on models. It has a single role named `modelData`, to match the behavior of lists. The same information contained in the list model is available as a normal list via the `values` property.

### Differences from a list

Unlike with a list, the following property binding will never be updated when `model[3]` changes.

```qml
// will not update reactively
property var foo: model[3]
```

You can work around this limitation using the `values` property of the model to view it as a list.

```qml
// will update reactively
property var foo: model.values[3]
```

## Properties

- **values**: `list<QtObject>` (readonly)
  The content of the object model, as a QML list. The values of this property will always be of the type of the model.

## Functions

- **indexOf()**: `int`
  No details provided.

## Signals

- **objectInsertedPre(object, index)**
  Sent immediately before an object is inserted into the model.
  - `object`: `QtObject`
  - `index`: `int`

- **objectRemovedPre(object, index)**
  Sent immediately before an object is removed from the model.
  - `object`: `QtObject`
  - `index`: `int`

- **objectInserted(object, index)**
  Sent immediately after an object is inserted into the model.
  - `object`: `QtObject`
  - `index`: `int`

- **objectRemoved(object, index)**
  Sent immediately after an object is removed from the model.
  - `object`: `QtObject`
  - `index`: `int`
