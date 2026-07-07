# RetainableLock

**Inherits:** [QObject](https://doc.qt.io/qt-6/qobject.html)

A helper for easily using Retainable.

This is a helper for easily using `Retainable` objects. A retainable object can be locked by multiple locks at once, and each lock re-exposes relevant properties of the retained objects.

### Example

The code below will keep a retainable object alive for as long as the RetainableLock exists.

```qml
RetainableLock {
  object: aRetainableObject
  locked: true
}
```

## Properties

- `locked` : `bool` - If the object should be locked.
- `object` : `QtObject` - The object to lock. Must be `Retainable`.
- `retained` : `bool` (readonly) - If the object is currently in a retained state.

## Signals

- `dropped()` - Rebroadcast of the object’s `Retainable.dropped()`.
- `aboutToDestroy()` - Rebroadcast of the object’s `Retainable.aboutToDestroy()`.
