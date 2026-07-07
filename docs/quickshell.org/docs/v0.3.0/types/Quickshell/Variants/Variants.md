# Variants
**Inherits:** [QObject](https://doc.qt.io/qt-6/qobject.html)

Creates instances of a component based on a given model.

`Variants` is similar to `Repeater` except it is for *non `Item`* objects, and acts as a reload scope.

Each non duplicate value passed to `model` will create a new instance of `delegate` with a `modelData` property set to that value.

See `Quickshell.screens` for an example of using `Variants` to create copies of a window per screen.

## Properties
* `delegate` : `Component` (default) - The component to create instances of. The delegate should define a `modelData` property that will be populated with a value from the `model`.
* `model` : `list<variant>` - The list of sets of properties to create instances with. Each set creates an instance of the component, which are updated when the input sets update.
* `instances` : `list<QtObject>` (readonly) - Current instances of the delegate.
