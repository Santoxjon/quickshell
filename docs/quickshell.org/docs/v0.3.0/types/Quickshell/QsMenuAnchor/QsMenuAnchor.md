# QsMenuAnchor

Display anchor for platform menus.

## Properties

- `menu`: `QsMenuHandle`
  The menu that should be displayed on this anchor.

- `visible`: `bool` (readonly)
  If the menu is currently open and visible.

- `anchor`: `PopupAnchor` (readonly)
  The menu’s anchor / positioner relative to another window. The menu will not be shown until it has a valid anchor.

## Functions

- `close()`: `void`
  Close the open menu.

- `open()`: `void`
  Open the given menu on this menu Requires that `anchor` is valid.

## Signals

- `opened()`
  Sent when the menu is displayed onscreen which may be after `visible` becomes true.

- `closed()`
  Sent when the menu is closed.
