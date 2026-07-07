---
title: Hyprland
---
[<i class="fa-solid fa-gears"></i> Quickshell.Hyprland](../Quickshell.Hyprland.index.md)

# Hyprland Type

## Inherits:
- [QtObject](https://doc.qt.io/qt-6/qobject.html)

## Description
Singleton for interacting with the Hyprland IPC.

## Properties
- <i class="fa-solid fa-lock"></i> `monitors` : `ObjectModel<HyprlandMonitor>` - All hyprland monitors.
- <i class="fa-solid fa-lock"></i> `activeToplevel` : `HyprlandToplevel` - Currently active toplevel (might be null)
- <i class="fa-solid fa-lock"></i> `toplevels` : `ObjectModel<HyprlandToplevel>` - All hyprland toplevels
- <i class="fa-solid fa-lock"></i> `workspaces` : `ObjectModel<HyprlandWorkspace>` - All hyprland workspaces, sorted by id.
- <i class="fa-solid fa-lock"></i> `eventSocketPath` : `string` - Path to the event socket (.socket2.sock)
- <i class="fa-solid fa-lock"></i> `focusedMonitor` : `HyprlandMonitor` - The currently focused hyprland monitor. May be null.
- <i class="fa-solid fa-lock"></i> `focusedWorkspace` : `HyprlandWorkspace` - The currently focused hyprland workspace. May be null.
- <i class="fa-solid fa-lock"></i> `requestSocketPath` : `string` - Path to the request socket (.socket.sock)
- <i class="fa-solid fa-lock"></i> `usingLua` : `bool` - True if Hyprland is running in lua mode. Dispatcher syntax changes when using lua.

## Functions
- `dispatch(request)` - Execute a hyprland dispatcher.
- `monitorFor(screen)` - Get the HyprlandMonitor object that corresponds to a quickshell screen.
- `refreshMonitors()` - Refresh monitor information.
- `refreshToplevels()` - Refresh toplevel information.
- `refreshWorkspaces()` - Refresh workspace information.

## Signals
- `rawEvent(event)` - Emitted for every event that comes in through the hyprland event socket (socket2).
