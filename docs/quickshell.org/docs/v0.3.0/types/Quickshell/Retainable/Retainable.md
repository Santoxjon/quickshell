# Retainable

**Inherits:** [QObject](https://doc.qt.io/qt-6/qobject.html)

Attached object for types that can have delayed destruction.

Some objects can be kept around (retained) after they would normally be destroyed, which is especially useful for things like exit transitions.

An object that is retainable will have `Retainable` as an attached property. All retainable objects will say that they are retainable on their respective typeinfo pages.

**Note:** Working directly with `Retainable` is often overly complicated and error prone. For this reason `RetainableLock` should usually be used instead.

## Properties

- `retained` : `bool` (readonly) - If the object is currently in a retained state.

## Functions

- `forceUnlock()` : `void` - Forcibly remove all locks, destroying the object. `unlock()` should usually be preferred.
- `lock()` : `void` - Hold a lock on the object so it cannot be destroyed. A counter is used to ensure you can lock the object from multiple places and it will not be unlocked until the same number of unlocks as locks have occurred.
- `unlock()` : `void` - Remove a lock on the object. See `lock()` for more information.

## Signals

- `dropped()` - This signal is sent when the object would normally be destroyed. If all signal handlers return and no locks are in place, the object will be destroyed. If at least one lock is present the object will be retained until all are removed.
- `aboutToDestroy()` - This signal is sent immediately before the object is destroyed. At this point destruction cannot be interrupted.
