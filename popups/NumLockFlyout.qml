import QtQuick
import Quickshell
import Quickshell.Io

import qs.components

LockStateFlyout {
    id: root

    readonly property int stateReadDelay: 10

    enabledIcon: "numLocked.png"
    disabledIcon: "numUnlocked.png"

    function refreshState(): void {
        readDelay.restart();
    }

    IpcHandler {
        target: "numLock"

        function refresh(): void {
            root.refreshState();
        }
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

        command: ["hyprctl", "devices", "-j"]

        stdout: StdioCollector {
            id: stateOutput

            onStreamFinished: {
                let devices;

                try {
                    devices = JSON.parse(stateOutput.text);
                } catch (error) {
                    console.warn(`NumLockFlyout: invalid hyprctl output: ${error}`);
                    return;
                }

                const keyboards = Array.isArray(devices.keyboards) ? devices.keyboards : [];
                const mainKeyboard = keyboards.find(keyboard => keyboard.main);

                if (!mainKeyboard)
                    return;

                root.showState(mainKeyboard.numLock === true);
            }
        }

        stderr: StdioCollector {
            id: stateError

            onStreamFinished: {
                const message = stateError.text.trim();

                if (message)
                    console.warn(`NumLockFlyout: ${message}`);
            }
        }
    }

}
