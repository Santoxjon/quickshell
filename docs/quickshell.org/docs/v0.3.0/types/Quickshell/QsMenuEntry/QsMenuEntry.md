# QsMenuEntry

Represents a single entry in a menu.

## Properties

- `hasChildren`: `bool` (readonly)
  If this menu item has children that can be accessed through a `QsMenuOpener`.

- `checkState`: `unknown` (readonly)
  The check state of the checkbox or radiobutton if applicable, as a `Qt.CheckState`.

- `text`: `string` (readonly)
  Text of the menu item.

- `buttonType`: `QsMenuButtonType` (readonly)
  If this menu item has an associated checkbox or radiobutton.

- `icon`: `string` (readonly)
  Url of the menu item’s icon or `""` if it doesn’t have one.

- `enabled`: `bool` (readonly)

- `isSeparator`: `bool` (readonly)
  If this menu item should be rendered as a separator between other items.

## Functions

- `display(parentWindow, relativeX, relativeY)`: `void`

## Signals

- `triggered()`
  Send a trigger/click signal to the menu entry.
