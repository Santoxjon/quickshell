import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire

PanelWindow {
    id: root

    required property var theme
    property bool opened: false
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var audio: root.sink ? root.sink.audio : null
    readonly property int volume: root.audio ? Math.round(root.audio.volume * 100) : 0
    readonly property int volumeStep: 5

    visible: root.opened || flyout.opacity > 0

    anchors {
        left: true
        right: true
        bottom: true
    }

    implicitHeight: root.theme.volumeFlyoutPanelHeight

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    focusable: false

    mask: Region {}

    function changeVolume(delta: int): void {
        if (!root.audio)
            return;

        const nextVolume = Math.max(0, Math.min(100, root.volume + delta));

        root.audio.volume = nextVolume / 100;

        root.opened = true;
        hideTimer.restart();
    }

    PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }

    GlobalShortcut {
        name: "volumeUp"
        description: "Raise volume"

        onPressed: root.changeVolume(root.volumeStep)
    }

    GlobalShortcut {
        name: "volumeDown"
        description: "Lower volume"

        onPressed: root.changeVolume(-root.volumeStep)
    }

    Timer {
        id: hideTimer

        interval: root.theme.volumeFlyoutDisplayDuration

        onTriggered: root.opened = false
    }

    Rectangle {
        id: flyout

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        width: root.theme.volumeFlyoutWidth
        height: root.theme.volumeFlyoutHeight

        radius: root.theme.volumeFlyoutRadius
        color: root.theme.bg

        opacity: root.opened ? root.theme.volumeFlyoutOpacity : 0

        transform: Translate {
            y: root.opened ? 0 : root.theme.volumeFlyoutHiddenOffset

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

        Row {
            anchors {
                fill: parent
                leftMargin: root.theme.volumeFlyoutHorizontalPadding
                rightMargin: root.theme.volumeFlyoutHorizontalPadding
            }

            spacing: root.theme.volumeFlyoutSpacing

            Text {
                anchors.verticalCenter: parent.verticalCenter

                text: ""
                color: root.theme.rightModuleIcon
                font.pixelSize: root.theme.titleSize
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter

                width: root.theme.volumeFlyoutBarWidth
                height: root.theme.audioSliderTrackHeight

                radius: root.theme.volumeFlyoutBarRadius
                color: root.theme.sliderEmptyBg
                clip: true

                Rectangle {
                    height: parent.height
                    width: parent.width * root.volume / 100

                    radius: parent.radius
                    color: root.theme.sliderBg

                    Behavior on width {
                        NumberAnimation {
                            duration: root.theme.fastAnimationDuration
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }
        }
    }
}
