# Quickshell configuration

A personal [Quickshell](https://quickshell.org/) configuration for Hyprland. It provides a top bar, workspace controls, system metrics, PipeWire audio controls, notification popups, lock-key flyouts, application indicators, and optional Corsair HS80 battery information.

## Features

- Hyprland workspaces with custom labels
- Centered clock
- Discord and Steam running indicators
- CPU usage with a per-core tooltip
- Used memory as a percentage or `used / total` in GB
- CPU temperature and local IPv4 address
- PipeWire volume display, scroll control, output selection, and volume flyout
- Desktop notification server with actions
- Caps Lock and Num Lock flyouts
- Optional Corsair HS80 battery and charging status

The shutdown icon is intentionally a placeholder and does not perform an action yet.

## Requirements

The configuration targets Quickshell 0.3 and Hyprland on Linux.

Install the following runtime dependencies with your distribution's package manager:

| Dependency | Used by |
| --- | --- |
| Quickshell | QML shell runtime and CLI (`qs`) |
| Hyprland | Workspaces, global shortcuts, IPC, client events |
| PipeWire and WirePlumber | Audio devices and volume control |
| JetBrainsMono Nerd Font | Text and status icons |
| Bash | Helper scripts |
| `jq` | Discord and Steam client detection |
| `socat` | Hyprland event-socket listener |
| `mpstat` from `sysstat` | CPU usage |
| `sensors` from `lm_sensors` | CPU temperature |
| `ip` from `iproute2` | Interface and IPv4 detection |

If `sensors` does not expose temperature readings after installation, run your distribution's recommended hardware-sensor detection step.

## Installation

Quickshell treats `~/.config/quickshell/shell.qml` as its default configuration. Clone this repository into that location:

```bash
git clone git@github.com:Santoxjon/quickshell.git ~/.config/quickshell
cd ~/.config/quickshell
chmod +x scripts/*.sh scripts/hs80-battery-daemon scripts/hs80-charging-daemon
```

If the repository is stored somewhere else, run it by path:

```bash
qs -p /path/to/quickshell
```

Start the default configuration manually while testing:

```bash
qs
```

Use verbose logging when diagnosing startup or QML errors:

```bash
qs -vv
```

Only one desktop notification server can normally own the notification bus. Stop or disable another notification daemon before starting this configuration if Quickshell reports a conflict.

## Start with Hyprland

Hyprland is configured through `~/.config/hypr/hyprland.lua`. Start Quickshell from the `hyprland.start` event handler:

```lua
hl.on("hyprland.start", function()
  hl.exec_cmd("qs")
end)
```

If the event handler already starts other desktop services, add only `hl.exec_cmd("qs")` inside the existing function. Restart Hyprland or run `qs` manually after making this change.

## Hyprland key bindings

The volume and lock-key flyouts need matching bindings in `hyprland.lua`:

```lua
hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.global("quickshell:volumeUp"),
  {
    locked = true,
    repeating = true,
  }
)

hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.global("quickshell:volumeDown"),
  {
    locked = true,
    repeating = true,
  }
)

hl.bind(
  "Num_Lock",
  hl.dsp.exec_cmd("sleep 0.15 && qs ipc call numLock refresh"),
  {
    non_consuming = true,
    description = "Show Num Lock state",
  }
)

hl.bind(
  "Caps_Lock",
  hl.dsp.global("quickshell:capsLock"),
  {
    non_consuming = true,
    description = "Show Caps Lock state",
  }
)
```

Muting is not handled by the volume flyout, but it can be bound separately through PipeWire:

```lua
hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  {
    locked = true,
  }
)
```

The shortcut names must match the `GlobalShortcut` and `IpcHandler` names in the QML files.

## Configuration

### Theme and font

Edit [`Theme.qml`](Theme.qml) to change the palette, font, sizes, and bar height. If a different Nerd Font is installed, update:

```qml
readonly property string fontName: "JetBrainsMono Nerd Font"
```

Missing or incorrect Nerd Font configuration usually appears as empty squares in place of icons.

### Workspaces

Edit [`modules/Workspaces.qml`](modules/Workspaces.qml) to change workspace labels. Workspaces 1 through 4 are always visible; workspaces 5 through 9 appear when they exist.

### Application indicators

[`scripts/app-indicator.sh`](scripts/app-indicator.sh) listens to Hyprland events and detects Discord-compatible clients and Steam. Update its process-class patterns and add matching images/components if more applications are needed.

### Audio outputs

The audio drawer lists PipeWire sinks whose names begin with `alsa_output.`. Change the filter in [`drawers/AudioDrawer.qml`](drawers/AudioDrawer.qml) to include other sink types, such as Bluetooth devices, when required.

### System metrics

The scripts under [`scripts/`](scripts/) continuously emit one line at a time for their QML modules:

- `get-cpu-usage.sh` emits CPU usage and per-core tooltip data as JSON.
- `get-memory-usage.sh` emits percentage and `used / total` RAM. Total RAM is rounded upward so a machine with approximately 31.3 GiB usable memory displays `32GB`.
- `get-cpu-temp.sh` prefers CPU package temperatures and supports common Intel, AMD, and CPU thermal-driver labels.
- `get-network-ip.sh` displays the IPv4 address of the default-route interface.

## Optional HS80 support

The audio drawer can display battery and charging information for a Corsair HS80. The two included binaries are x86-64 Linux executables that locate the matching `hidraw` device and write state to:

```text
/run/hs80-battery
/run/hs80-charging
```

Rebuild the binaries from source when using another architecture or after changing their code:

```bash
cc -std=c17 -O2 -Wall -Wextra -Wpedantic -o scripts/hs80-battery-daemon scripts/hs80-battery-daemon.c
cc -std=c17 -O2 -Wall -Wextra -Wpedantic -o scripts/hs80-charging-daemon scripts/hs80-charging-daemon.c
```

The daemons need permission to read `/dev/hidraw*` and write under `/run`. One option is to run them as system services. Create `/etc/systemd/system/hs80-battery-daemon.service`:

```ini
[Unit]
Description=Corsair HS80 battery daemon
After=multi-user.target

[Service]
Type=simple
ExecStart=/home/USER/.config/quickshell/scripts/hs80-battery-daemon
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
```

Create `/etc/systemd/system/hs80-charging-daemon.service`:

```ini
[Unit]
Description=Corsair HS80 charging-state daemon
After=multi-user.target

[Service]
Type=simple
ExecStart=/home/USER/.config/quickshell/scripts/hs80-charging-daemon
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
```

Replace `USER` with the account name and adjust the repository path if necessary. Then load and enable both services:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now hs80-battery-daemon.service hs80-charging-daemon.service
```

Check their status and generated files with:

```bash
systemctl status hs80-battery-daemon.service hs80-charging-daemon.service
cat /run/hs80-battery /run/hs80-charging
```

HS80 support is optional; the rest of the shell works without these services.

## Repository layout

```text
shell.qml       Main Quickshell entry point
Theme.qml       Shared colors, fonts, and dimensions
panels/         Top-level panel windows
modules/        Complete bar features and status modules
components/     Reusable visual primitives
services/       Nonvisual state and process adapters
drawers/        Expandable audio-device UI
popups/         Notifications, tooltips, and flyouts
scripts/        System-information helpers and HS80 daemons
assets/         Application and lock-state images
```

## Troubleshooting

- Run `qs -vv` and inspect the terminal output for missing imports or commands.
- Confirm the helper commands with `command -v jq socat mpstat sensors ip hyprctl`.
- If CPU temperature shows `--°C`, run `sensors` and check that a CPU temperature source is present.
- If volume is unavailable, verify that PipeWire and WirePlumber are running and expose a default audio sink.
- If app indicators do not update, check the Hyprland event socket and verify that `socat` and `jq` are installed.
- If lock flyouts do not appear, verify the shortcut names and run `qs ipc call numLock refresh` manually for Num Lock.
- If icons render as boxes, install JetBrainsMono Nerd Font or change `fontName` in `Theme.qml`.
