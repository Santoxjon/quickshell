import QtQuick
import Quickshell
import Quickshell.Io

PanelWindow {
    id: root

    required property var theme

    property bool numLockEnabled: false
    property bool opened: false

    readonly property int stateReadDelay: 10
    readonly property int displayDuration: 850

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

                root.numLockEnabled = mainKeyboard.numLock === true;
                root.opened = true;
                hideTimer.restart();
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

            source: Quickshell.shellDir + "/assets/" + (root.numLockEnabled ? "numLocked.png" : "numUnlocked.png")

            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
        }
    }
}
