import QtQuick
import Quickshell.Hyprland
import Quickshell.Io

import qs.components

LockStateFlyout {
    id: root

    property bool stateInitialized: false
    property var previousLedStates: ({})

    readonly property int stateReadDelay: 40

    enabledIcon: "capsLocked.png"
    disabledIcon: "capsUnlocked.png"
    displayDuration: 500

    Component.onCompleted: stateReader.running = true

    function refreshState(): void {
        readDelay.restart();
    }

    GlobalShortcut {
        name: "capsLock"
        description: "Show caps lock state flyout"

        onPressed: root.refreshState()
    }

    Timer {
        id: readDelay

        interval: root.stateReadDelay

        onTriggered: {
            if (!stateReader.running)
                stateReader.running = true;
        }
    }

    Process {
        id: stateReader

        command: ["sh", "-c", "for f in /sys/class/leds/input*::capslock/brightness; do " + "[ -r \"$f\" ] || continue; " + "printf '%s=' \"$f\"; " + "cat \"$f\"; " + "done"]

        stdout: StdioCollector {
            id: stateOutput

            onStreamFinished: {
                const currentStates = {};
                const lines = stateOutput.text.trim().split("\n");

                for (const line of lines) {
                    const separator = line.lastIndexOf("=");

                    if (separator === -1)
                        continue;

                    const path = line.substring(0, separator);
                    const value = Number.parseInt(line.substring(separator + 1), 10);

                    if (Number.isFinite(value))
                        currentStates[path] = value > 0;
                }

                if (Object.keys(currentStates).length === 0) {
                    console.warn("CapsLockFlyout: no readable Caps Lock LEDs found");
                    return;
                }

                if (!root.stateInitialized) {
                    root.previousLedStates = currentStates;
                    root.lockEnabled = Object.values(currentStates).some(enabled => enabled);
                    root.stateInitialized = true;
                    return;
                }

                let changedState = null;

                for (const path in currentStates) {
                    if (root.previousLedStates[path] !== undefined && root.previousLedStates[path] !== currentStates[path]) {
                        changedState = currentStates[path];
                        break;
                    }
                }

                root.previousLedStates = currentStates;
                root.showState(changedState ?? !root.lockEnabled);
            }
        }

        stderr: StdioCollector {
            id: stateError

            onStreamFinished: {
                const message = stateError.text.trim();

                if (message)
                    console.warn(`CapsLockFlyout: ${message}`);
            }
        }
    }

}
