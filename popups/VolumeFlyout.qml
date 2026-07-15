// popups/VolumeFlyout.qml
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire

PanelWindow {
    id: root

    required property var theme

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var audio: sink ? sink.audio : null

    readonly property int volume: audio ? Math.round(audio.volume * 100) : 0

    property bool opened: false

    visible: opened || flyout.opacity > 0

    anchors {
        left: true
        right: true
        bottom: true
    }

    margins.bottom: 0

    implicitHeight: 84

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    focusable: false

    mask: Region {}

    function changeVolume(delta) {
        if (!audio)
            return;

        const current = Math.round(audio.volume * 100);
        const next = Math.max(0, Math.min(100, current + delta));

        audio.volume = next / 100;

        root.opened = true;
        hideTimer.restart();
    }

    PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }

    GlobalShortcut {
        name: "volumeUp"
        description: "Subir volumen"

        onPressed: root.changeVolume(5)
    }

    GlobalShortcut {
        name: "volumeDown"
        description: "Bajar volumen"

        onPressed: root.changeVolume(-5)
    }

    Timer {
        id: hideTimer

        interval: 1000
        repeat: false

        onTriggered: root.opened = false
    }

    Rectangle {
        id: flyout

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        width: 325
        height: 40

        radius: 30
        color: root.theme.bg

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

        Row {
            anchors {
                fill: parent
                leftMargin: 18
                rightMargin: 18
            }

            spacing: 14

            Text {
                anchors.verticalCenter: parent.verticalCenter

                text: ""
                color: root.theme.rightModuleIcon

                font {
                    family: root.theme.fontFamily
                    pixelSize: 25
                }
            }

            Rectangle {
                id: volumeBar

                anchors.verticalCenter: parent.verticalCenter

                width: 245
                height: 15

                radius: 3
                color: root.theme.sliderEmptyBg
                clip: true

                Rectangle {
                    height: parent.height
                    width: parent.width * root.volume / 100

                    radius: parent.radius
                    color: root.theme.sliderBg

                    Behavior on width {
                        NumberAnimation {
                            duration: 80
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }
        }
    }
}
