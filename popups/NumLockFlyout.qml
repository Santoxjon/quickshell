// popups/NumLockFlyout.qml
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

PanelWindow {
    id: root

    required property var theme

    property bool numLockEnabled: false
    property bool opened: false

    visible: opened || flyout.opacity > 0

    anchors {
        left: true
        right: true
        bottom: true
    }

    margins.bottom: 100

    implicitHeight: 150

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    focusable: false

    mask: Region {}

    function refreshState() {
        readDelay.restart();
    }

    GlobalShortcut {
        name: "numLock"
        description: "Mostrar estado de Num Lock"

        onPressed: root.refreshState()
    }

    Timer {
        id: readDelay

        interval: 40
        repeat: false

        onTriggered: {
            if (!stateReader.running)
                stateReader.running = true;
        }
    }

    property var previousLedStates: ({})
    property bool ledStatesInitialized: false

    Component.onCompleted: stateReader.running = true

    Process {
        id: stateReader

        running: false

        command: ["sh", "-c", "for f in /sys/class/leds/input*::numlock/brightness; do " + "[ -r \"$f\" ] || continue; " + "printf '%s=' \"$f\"; " + "cat \"$f\"; " + "done"]

        stdout: StdioCollector {
            onStreamFinished: {
                const currentStates = {};
                const lines = text.trim().split("\n");

                for (const line of lines) {
                    const separator = line.lastIndexOf("=");

                    if (separator === -1)
                        continue;

                    const path = line.substring(0, separator);
                    const value = parseInt(line.substring(separator + 1), 10);

                    currentStates[path] = value > 0;
                }

                if (!root.ledStatesInitialized) {
                    // Primera lectura: solo guardamos el estado inicial.
                    root.previousLedStates = currentStates;
                    root.ledStatesInitialized = true;
                    return;
                }

                let changedState = null;

                for (const path in currentStates) {
                    if (root.previousLedStates[path] === undefined)
                        continue;

                    if (root.previousLedStates[path] !== currentStates[path]) {
                        changedState = currentStates[path];
                        break;
                    }
                }

                if (changedState !== null) {
                    root.numLockEnabled = changedState;
                } else {
                    root.numLockEnabled = !root.numLockEnabled;
                }

                root.previousLedStates = currentStates;
                root.opened = true;
                hideTimer.restart();
            }
        }
    }

    Timer {
        id: hideTimer

        interval: 500
        repeat: false

        onTriggered: root.opened = false
    }

    Rectangle {
        id: flyout

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        width: 120
        height: 120

        radius: 20
        color: root.theme.palette2

        opacity: root.opened ? 0.9 : 0

        transform: Translate {
            y: root.opened ? 0 : 16

            Behavior on y {
                NumberAnimation {
                    duration: 220
                    easing.type: Easing.OutCubic
                }
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutCubic
            }
        }

        Image {
            anchors.centerIn: parent

            width: 100
            height: 100

            source: Quickshell.shellDir + "/assets/" + (root.numLockEnabled ? "numUnlocked.png" : "numLocked.png")

            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
        }
    }
}
