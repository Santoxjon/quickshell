import QtQuick
import QtQuick.Layouts
import Quickshell

import "../components"

PanelWindow {
    id: root

    required property var theme
    property bool activeBorder: false

    signal audioHovered
    signal audioUnhovered

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: root.theme.barHeight
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: root.theme.bg
        clip: true

        RowLayout {
            anchors.fill: parent
            anchors.rightMargin: root.theme.topBarContentRightMargin
            spacing: 0

            Item {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                Layout.fillHeight: true

                Workspaces {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    theme: root.theme
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                Layout.fillHeight: true

                Clock {
                    anchors.centerIn: parent
                    theme: root.theme
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                Layout.fillHeight: true

                RightModules {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    theme: root.theme

                    onAudioHovered: root.audioHovered()
                    onAudioUnhovered: root.audioUnhovered()
                }
            }
        }

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: root.theme.accentBorderWidth
            color: root.theme.topBarBottomBorder

            opacity: root.activeBorder ? 1 : 0

            Behavior on opacity {
                NumberAnimation {
                    duration: root.activeBorder ? 0 : root.theme.animationDuration
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
}
