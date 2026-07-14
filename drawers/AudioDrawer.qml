// drawers/AudioDrawer.qml
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire

import "../components"

PopupWindow {
    id: root

    required property var theme
    required property var anchorWindow
    property bool opened: false
    property bool animating: false
    readonly property bool fullyOpened: box.fullyOpened

    visible: opened || animating
    color: "transparent"
    implicitWidth: 320
    implicitHeight: Pipewire.nodes.values.filter(node => node.isSink && node.name && node.name.startsWith("alsa_output.")).length * 36 + 12 + 10 + 26 + 28 + 15 + 40

    anchor.window: anchorWindow
    anchor.rect.x: anchorWindow.width - implicitWidth - 30
    anchor.rect.y: root.theme.barHeight - 3

    AudioDrawerBackground {
        id: box
        theme: root.theme
        opened: root.opened
        implicitHeight: root.implicitHeight

        Column {
            anchors.fill: parent
            anchors.leftMargin: 12 + box.lip
            anchors.rightMargin: 12 + box.lip
            anchors.topMargin: 12
            anchors.bottomMargin: 12
            spacing: 10
            opacity: box.height / root.implicitHeight

            ModuleText {
                theme: root.theme
                text: "Salidas"
                font.pixelSize: root.theme.titleSize
                font.italic: true
            }

            Repeater {
                model: Pipewire.nodes.values.filter(node => node.isSink && node.name && node.name.startsWith("alsa_output."))

                delegate: Item {
                    width: parent.width
                    height: 26
                    readonly property bool isCurrent: modelData === Pipewire.defaultAudioSink
                    readonly property bool isHS80: modelData.description && modelData.description.includes("HS80")
                    readonly property string hs80Info: isHS80 && hs80Status.batteryText ? ` ${hs80Status.icon}` : ""

                    ModuleText {
                        anchors.verticalCenter: parent.verticalCenter
                        theme: root.theme

                        text: `${isCurrent ? "●" : "○"} ${modelData.description}${hs80Info}`
                        color: isCurrent ? root.theme.audioOutputActiveText : root.theme.audioOutputText

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Pipewire.preferredDefaultAudioSink = modelData
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 2
                color: root.theme.border
            }

            ModuleText {
                theme: root.theme
                text: "Volumen " + Math.round(volumeSlider.value) + "%"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            AudioSlider {
                id: volumeSlider
                theme: root.theme
            }
        }
    }

    HoverHandler {
        onHoveredChanged: hovered ? root.entered() : root.exited()
    }

    onOpenedChanged: {
        if (opened) {
            animating = true;
        } else {
            closeTimer.restart();
        }
    }

    Timer {
        id: closeTimer
        interval: 230
        repeat: false
        onTriggered: root.animating = false
    }

    PwObjectTracker {
        objects: Pipewire.nodes.values
    }

    Hs80Status {
        id: hs80Status
        active: root.opened
    }

    signal entered
    signal exited
}
