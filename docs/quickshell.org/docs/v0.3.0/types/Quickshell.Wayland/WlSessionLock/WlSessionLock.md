# WlSessionLock
**Version:** v0.3.0
**Description:** Wayland session locker.

WlSessionLock will create an instance of its `surface` component for every screen when `locked` is set to true. The `surface` component must create a [WlSessionLockSurface](../WlSessionLockSurface/WlSessionLockSurface.md) which will be displayed on each screen.

The below example will create a session lock that disappears when the button is clicked.

```qml
WlSessionLock {
  id: lock

  WlSessionLockSurface {
    Button {
      text: "unlock me"
      onClicked: lock.locked = false
    }
  }
}

// ...
lock.locked = true
```

> **WARNING**
> If the WlSessionLock is destroyed or quickshell exits without setting `locked` to false, conformant compositors will leave the screen locked and painted with a solid color.
>
> This is what makes the session lock secure. The lock dying will not expose your session, but it will render it inoperable.

## Properties
- `secure`: `bool` (readonly) - The compositor lock state. This is set to true once the compositor has confirmed all screens are covered with locks.
- `locked`: `bool` - Controls the lock state.
> **WARNING**
> Only one WlSessionLock may be locked at a time. Attempting to enable a lock while another lock is enabled will do nothing.
- `surface`: `Component` (default) - The surface that will be created for each screen. Must create a [WlSessionLockSurface](../WlSessionLockSurface/WlSessionLockSurface.md).
