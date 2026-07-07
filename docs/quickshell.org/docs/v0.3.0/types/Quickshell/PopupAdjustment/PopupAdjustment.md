# PopupAdjustment

Adjustment strategy for popups that do not fit on screen.

This enum is used by `PopupAnchor.adjustment`.

Adjustment flags can be combined with the `|` operator.

`Flip` will be applied first, then `Slide`, then `Resize`.

## Variants

- **ResizeY**
  If the Y axis is constrained, the height of the popup will be reduced to fit on screen.

- **SlideY**
  If the Y axis is constrained, the popup will slide along the Y axis until it fits onscreen.

- **Slide**
  Same as `SlideX | SlideY`

- **ResizeX**
  If the X axis is constrained, the width of the popup will be reduced to fit on screen.

- **Resize**
  Same as `ResizeX | ResizeY`

- **FlipY**
  If the popup is constrained on the Y axis, it will flip to the other side of its parent.

- **FlipX**
  If the popup is constrained on the X axis, it will flip to the other side of its parent.

- **Flip**
  Same as `FlipX | FlipY`

- **None**
  The popup will not be adjusted.
