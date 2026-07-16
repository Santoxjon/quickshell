pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

import qs.components
import qs.services

PopupWindow {
    id: root

    required property var theme
    required property var anchorWindow
    property bool opened: false
    property bool animating: false
    readonly property var outputSinks: Pipewire.nodes.values.filter(node => node.isSink && node.name && node.name.startsWith("alsa_output."))
    readonly property bool fullyOpened: box.fullyOpened

    signal entered
    signal exited

    visible: root.opened || root.animating
    color: "transparent"
    implicitWidth: root.theme.audioDrawerWidth
    implicitHeight: content.implicitHeight + root.theme.drawerContentPadding * 2

    anchor.window: root.anchorWindow
    anchor.rect.x: root.anchorWindow.width - root.implicitWidth - root.theme.audioDrawerRightMargin
    anchor.rect.y: root.theme.barHeight - root.theme.accentBorderWidth

    DrawerBackground {
        id: box
        theme: root.theme
        opened: root.opened
        implicitHeight: root.implicitHeight

        Column {
            id: content

            anchors.fill: parent
            anchors.leftMargin: root.theme.drawerContentPadding + box.lip
            anchors.rightMargin: root.theme.drawerContentPadding + box.lip
            anchors.topMargin: root.theme.drawerContentPadding
            anchors.bottomMargin: root.theme.drawerContentPadding
            spacing: root.theme.audioDrawerContentSpacing
            opacity: box.height / root.implicitHeight

            ModuleText {
                theme: root.theme
                text: "Outputs"
                font.pixelSize: root.theme.titleSize
                font.italic: true
            }

            Repeater {
                model: root.outputSinks

                delegate: Item {
                    id: outputRow

                    required property var modelData
                    readonly property string outputName: outputRow.modelData.description || outputRow.modelData.name
                    readonly property bool isCurrent: outputRow.modelData === Pipewire.defaultAudioSink
                    readonly property bool isHS80: outputRow.outputName.includes("HS80")
                    readonly property string hs80Info: outputRow.isHS80 && hs80Status.batteryText ? ` ${hs80Status.icon}` : ""

                    width: parent.width
                    height: root.theme.audioOutputRowHeight

                    ModuleText {
                        anchors.verticalCenter: parent.verticalCenter
                        theme: root.theme

                        text: `${outputRow.isCurrent ? "●" : "○"} ${outputRow.outputName}${outputRow.hs80Info}`
                        color: outputRow.isCurrent ? root.theme.audioOutputActiveText : root.theme.audioOutputText
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        onClicked: Pipewire.preferredDefaultAudioSink = outputRow.modelData
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: root.theme.borderWidth
                color: root.theme.border
            }

            ModuleText {
                theme: root.theme
                text: "Volume " + Math.round(volumeSlider.value) + "%"
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
        if (root.opened) {
            closeTimer.stop();
            root.animating = true;
        } else {
            closeTimer.restart();
        }
    }

    Timer {
        id: closeTimer

        interval: root.theme.drawerCloseDelay

        onTriggered: root.animating = false
    }

    PwObjectTracker {
        objects: root.outputSinks
    }

    Hs80Status {
        id: hs80Status
        active: root.opened
    }
}
