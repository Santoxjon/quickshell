# ClippingWrapperRectangle
**Version:** v0.3.0
**Description:** ClippingRectangle that handles sizes and positioning for a single visual child.

This type can be used to easily create custom components that have a single visual child that determines the size of the component.

## Properties
- `item`: `Item` (readonly) - The child item.
- `source`: `Component` - The component to create as a child.
- `verticalAlignment`: `enum` - The vertical alignment of the child.
  - `WrapperRectangle.AlignVCenter`
  - `WrapperRectangle.AlignVTop`
  - `WrapperRectangle.AlignVBottom`
- `horizontalAlignment`: `enum` - The horizontal alignment of the child.
  - `WrapperRectangle.AlignHCenter`
  - `WrapperRectangle.AlignHLeft`
  - `WrapperRectangle.AlignHRight`
- `paddings`: `real` - The padding around the child.
- `topPadding`: `real` - The top padding.
- `bottomPadding`: `real` - The bottom padding.
- `leftPadding`: `real` - The left padding.
- `rightPadding`: `real` - The right padding.
- `implicitContentWidth`: `real` (readonly) - The implicit width of the content.
- `implicitContentHeight`: `real` (readonly) - The implicit height of the content.
