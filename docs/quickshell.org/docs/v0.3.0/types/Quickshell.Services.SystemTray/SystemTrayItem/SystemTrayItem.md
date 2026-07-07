# Quickshell.Services.SystemTray - SystemTrayItem
**Version:** v0.3.0
**Description:** An item in the system tray.
## Properties
* `status` (Status): 
* `category` (Category): 
* `id` (string): A name unique to the application, such as its name.
* `menu` (unknown): A handle to the menu associated with this tray item, if any.
* `hasMenu` (bool): If this tray item has an associated menu accessible via display() or menu.
* `onlyMenu` (bool): If this tray item only offers a menu and activation will do nothing.
* `icon` (string): Icon source string, usable as an Image source.
* `tooltipDescription` (string): 
* `title` (string): Text that describes the application.
* `tooltipTitle` (string): 
## Functions
* `activate(): void` - Primary activation action, generally triggered via a left click.
* `display(parentWindow: QtObject, relativeX: int, relativeY: int): void` - Display the menu, if any, at the given position relative to a window.
* `scroll(delta: int, horizontal: bool): void` - Scroll action, such as changing volume on a mixer.
* `secondaryActivate(): void` - Secondary activation action, generally triggered via a middle click.
## Signals
* `ready()` - 
