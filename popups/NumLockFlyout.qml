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

    IpcHandler {
        target: "numLock"

        function refresh(): void {
            root.refreshState();
        }
    }

    Timer {
        id: readDelay

        interval: 10
        repeat: false

        onTriggered: {
            if (!stateReader.running)
                stateReader.running = true;
        }
    }

    Process {
        id: stateReader

        running: false
        command: ["hyprctl", "devices", "-j"]

        stdout: StdioCollector {
            onStreamFinished: {
                let devices;

                try {
                    devices = JSON.parse(text);
                } catch (error) {
                    return;
                }

                const keyboards = devices.keyboards || [];
                let mainKeyboard = null;

                for (const keyboard of keyboards) {
                    if (keyboard.main) {
                        mainKeyboard = keyboard;
                        break;
                    }
                }

                if (!mainKeyboard) {
                    return;
                }

                root.numLockEnabled = mainKeyboard.numLock === true;

                root.opened = true;
                hideTimer.restart();
            }
        }
    }

    Timer {
        id: hideTimer

        interval: 850
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
                    duration: 250
                    easing.type: Easing.OutCubic
                }
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

        Image {
            anchors.centerIn: parent

            width: 100
            height: 100

            source: Quickshell.shellDir + "/assets/" + (!root.numLockEnabled ? "numUnlocked.png" : "numLocked.png")

            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
        }
    }
}
