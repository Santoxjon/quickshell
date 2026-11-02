import QtQuick
import Quickshell.Io

import qs.components

LockStateFlyout {
    id: root

    property bool stateInitialized: false
    property var previousLedStates: ({})

    enabledIcon: "numLocked.png"
    disabledIcon: "numUnlocked.png"

    Component.onCompleted: stateReader.running = true

    Timer {
        interval: 250
        repeat: true
        running: true
        onTriggered: {
            if (!stateReader.running)
                stateReader.running = true;
        }
    }

    Process {
        id: stateReader

        command: ["sh", "-c", "for f in /sys/class/leds/input*::numlock/brightness; do " + "[ -r \"$f\" ] || continue; " + "printf '%s=' \"$f\"; " + "cat \"$f\"; " + "done"]

        stdout: StdioCollector {
            id: stateOutput

            onStreamFinished: {
                const currentStates = {};
                const lines = stateOutput.text.trim().split("\n");

                for (const line of lines) {
                    const separator = line.lastIndexOf("=");
                    if (separator === -1)
                        continue;

                    const value = Number.parseInt(line.substring(separator + 1), 10);
                    if (Number.isFinite(value))
                        currentStates[line.substring(0, separator)] = value > 0;
                }

                const paths = Object.keys(currentStates);
                if (paths.length === 0)
                    return;

                const enabled = Object.values(currentStates).some(value => value);
                if (!root.stateInitialized) {
                    root.previousLedStates = currentStates;
                    root.lockEnabled = enabled;
                    root.stateInitialized = true;
                    return;
                }

                let changed = false;
                for (const path of paths) {
                    if (root.previousLedStates[path] !== undefined && root.previousLedStates[path] !== currentStates[path]) {
                        changed = true;
                        break;
                    }
                }

                root.previousLedStates = currentStates;
                if (changed)
                    root.showState(enabled);
            }
        }
    }
}
