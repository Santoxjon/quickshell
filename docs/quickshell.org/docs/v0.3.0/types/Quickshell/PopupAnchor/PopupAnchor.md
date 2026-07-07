# PopupAnchor

**Inherits**: `QObject`

Anchorpoint or positioner for popup windows.

This type is used to anchor a popup window to an item or a rectangle on screen.
It provides a flexible way to position popups relative to other elements.

## Properties

-   **margins**: `[left,top,right,bottom]`
    The margins around the anchor rectangle.

-   **adjustment**: `PopupAdjustment`
    The strategy used to adjust the popup’s position if it would otherwise not fit on screen.

-   **edges**: `Edges`
    The point on the anchor rectangle the popup should anchor to.

-   **rect**: `[width,x,y,height,w,h]`
    The anchor rectangle.

-   **window**: `QtObject`
    The window to anchor / attach the popup to.

-   **gravity**: `Edges`
    The direction the popup should expand towards, relative to the anchorpoint.

-   **item**: `Item`
    The item to anchor / attach the popup to.

## Functions

-   **updateAnchor()**: `void`
    Update the popup’s anchor rect relative to its parent window.

## Signals

-   **anchoring()**
    Emitted when this anchor is about to be used.
