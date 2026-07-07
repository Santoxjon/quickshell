# Quickshell.Wayland - ScreencopyView
**Version:** v0.3.0
**Description:** Displays a video stream from other windows or a monitor.

A ScreencopyView can be used to display a video stream from a variety of capture sources. See `captureSource` for details on which objects are accepted.

## Properties
* `captureSource`: `QtObject` - The object to capture from. Accepts any of the following:
    * `null` - Clears the displayed image.
    * `ShellScreen` - A monitor. Requires a compositor that supports `wlr-screencopy-unstable` or both `ext-image-copy-capture-v1` and `ext-capture-source-v1`.
    * `Toplevel` - A toplevel window. Requires a compositor that supports `hyprland-toplevel-export-v1`.
* `constraintSize`: `unknown` - If nonzero, the width and height constraints set for this property will constrain those dimensions of the ScreencopyView’s implicit size, maintaining the image’s aspect ratio.
* `paintCursor`: `bool` - If true, the system cursor will be painted on the image. Defaults to false.
* `hasContent`: `bool` (readonly) - If true, the view has content ready to display. Content is not always immediately available, and this property can be used to avoid displaying it until ready.
* `live`: `bool` - If true, a live video feed from the capture source will be displayed instead of a still image. Defaults to false.
* `sourceSize`: `size` (readonly) - The size of the source image. Valid when `hasContent` is true.

## Functions
* `captureFrame()`: `void` - Capture a single frame. Has no effect if `live` is true.

## Signals
* `stopped()` - The compositor has ended the video stream. Attempting to restart it may or may not work.
