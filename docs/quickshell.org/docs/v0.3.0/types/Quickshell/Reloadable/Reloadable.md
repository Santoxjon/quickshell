# Reloadable

**Inherits:** [QObject](https://doc.qt.io/qt-6/qobject.html)

The base class of all types that can be reloaded.

When quickshell reloads, it attempts to retain the state of some objects. For example, windows should not be recreated, but instead their properties should be updated. This is done by marking them as `Reloadable`.

Some examples are `ProxyWindowBase` and `PersistentProperties`.

## Properties

- `reloadableId` : `string` - An additional identifier that can be used to try to match a reloadable object to its previous state. Simply keeping a stable identifier across config versions (saves) is enough to help the reloader figure out which object in the old revision corresponds to this object in the current revision, and facilitate smoother reloading. Note that identifiers are scoped, and will try to do the right thing in context. For example if you have a `Variants` wrapping an object with an identified element inside, a scope is created at the variant level.
