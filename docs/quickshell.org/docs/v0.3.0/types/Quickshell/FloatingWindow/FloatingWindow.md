# FloatingWindow

**Inherits**: `QsWindow`

Standard toplevel operating system window that looks like any other application.

## Properties

-   `title`: `string` - Window title.
-   `maximized`: `bool` - Whether the window is currently maximized.
-   `maximumSize`: `size` - Maximum window size given to the window system.
-   `parentWindow`: `QtObject` - The parent window of this window. Setting this makes the window a child of the parent, which affects window stacking behavior. This property cannot be changed after the window is visible.
-   `minimumSize`: `size` - Minimum window size given to the window system.
-   `minimized`: `bool` - Whether the window is currently minimized.
-   `fullscreen`: `bool` - Whether the window is currently fullscreen.

## Functions

-   `startSystemMove()`: `bool` - Start a system move operation. Must be called during a pointer press/drag.
-   `startSystemResize(edges)`: `bool` - Start a system resize operation. Must be called during a pointer press/drag.
