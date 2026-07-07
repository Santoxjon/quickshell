# GlobalShortcut
**Inherits:** `QtObject`

Hyprland global shortcut.

## Properties
* `description` : `string` - The description of the shortcut that appears in `hyprctl globalshortcuts`.
* `name` : `string` - The name of the shortcut.
* `pressed` : `bool` (readonly) - If the keybind is currently pressed.
* `appid` : `string` - The appid of the shortcut. Defaults to `quickshell`.
* `triggerDescription` : `string` - Have not seen this used ever, but included for completeness. Safe to ignore.

## Signals
* `released()` - Fired when the keybind is released.
* `pressed()` - Fired when the keybind is pressed.
