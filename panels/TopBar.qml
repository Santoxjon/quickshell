import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.modules

PanelWindow {
    id: root

    required property var theme
    required property var cpuUsage
    property bool activeBorder: false

    readonly property Item cpuAnchorItem: rightModules.cpuAnchorItem

    signal audioHovered
    signal audioUnhovered
    signal cpuHovered
    signal cpuUnhovered

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
                    id: rightModules

                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    theme: root.theme
                    cpuUsage: root.cpuUsage

                    onAudioHovered: root.audioHovered()
                    onAudioUnhovered: root.audioUnhovered()
                    onCpuHovered: root.cpuHovered()
                    onCpuUnhovered: root.cpuUnhovered()
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
