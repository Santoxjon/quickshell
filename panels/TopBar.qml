import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import "../components"

PanelWindow {
    id: bar

    required property var theme

    signal audioHovered
    signal audioUnhovered

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: theme.barHeight
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: theme.bg
        clip: true

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 0
            anchors.rightMargin: 5
            spacing: 0

            Item {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                height: parent.height

                Workspaces {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    theme: bar.theme
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                height: parent.height

                Clock {
                    anchors.centerIn: parent
                    theme: bar.theme
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                height: parent.height

                RightModules {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    theme: bar.theme

                    onAudioHovered: bar.audioHovered()
                    onAudioUnhovered: bar.audioUnhovered()
                }
            }
        }
    }
}
