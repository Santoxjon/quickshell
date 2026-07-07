# TransformWatcher
**Inherits:** [QObject](https://doc.qt.io/qt-6/qobject.html)

Monitor of all geometry changes between two objects.

This is a low-level utility for watching all geometry changes of two Items relative to eachother.

## Properties
* `transform` : `QtObject` (readonly) - This property is updated whenever the geometry of any item in the path from `a` to `b` changes.
* `b` : `Item`
* `commonParent` : `Item` - Known common parent of both `a` and `b`. Defaults to `null`.
* `a` : `Item`
