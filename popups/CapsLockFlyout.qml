import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

PanelWindow {
    id: root

    required property var theme

    property bool capsLockEnabled: false
    property bool opened: false
    property bool stateInitialized: false
    property var previousLedStates: ({})

    readonly property int stateReadDelay: 40
    readonly property int displayDuration: 500

    visible: root.opened || flyout.opacity > 0

    anchors {
        left: true
        right: true
        bottom: true
    }

    margins.bottom: root.theme.lockFlyoutBottomMargin

    implicitHeight: root.theme.lockFlyoutPanelHeight

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    focusable: false

    mask: Region {}

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
                    root.capsLockEnabled = Object.values(currentStates).some(enabled => enabled);
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

                root.capsLockEnabled = changedState ?? !root.capsLockEnabled;
                root.previousLedStates = currentStates;
                root.opened = true;
                hideTimer.restart();
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

    Timer {
        id: hideTimer

        interval: root.displayDuration

        onTriggered: root.opened = false
    }

    Rectangle {
        id: flyout

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        width: root.theme.lockFlyoutSize
        height: root.theme.lockFlyoutSize

        radius: root.theme.lockFlyoutRadius
        color: root.theme.lockFlyoutBg

        opacity: root.opened ? root.theme.lockFlyoutOpacity : 0

        transform: Translate {
            y: root.opened ? 0 : root.theme.lockFlyoutHiddenOffset

            Behavior on y {
                NumberAnimation {
                    duration: root.theme.animationDuration
                    easing.type: Easing.OutCubic
                }
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: root.theme.animationDuration
                easing.type: Easing.OutCubic
            }
        }

        Image {
            anchors.centerIn: parent

            width: root.theme.lockFlyoutIconSize
            height: width

            source: Quickshell.shellDir + "/assets/" + (root.capsLockEnabled ? "capsLocked.png" : "capsUnlocked.png")

            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
        }
    }
}
