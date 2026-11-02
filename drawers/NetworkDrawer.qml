pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.components

PopupWindow {
    id: root

    required property var theme
    required property Item anchorItem
    required property var networkModule
    property bool opened: false
    property bool animating: false
    readonly property bool fullyOpened: box.fullyOpened

    visible: root.opened || root.animating
    color: "transparent"
    implicitWidth: content.implicitWidth + (root.theme.drawerContentPadding + root.theme.drawerLip) * 2
    implicitHeight: content.implicitHeight + root.theme.drawerContentPadding * 2

    anchor.item: root.anchorItem
    anchor.rect.x: (root.anchorItem.width - root.implicitWidth) / 2
    anchor.rect.y: (root.theme.barHeight + root.anchorItem.height) / 2 - root.theme.accentBorderWidth

    DrawerBackground {
        id: box

        theme: root.theme
        opened: root.opened
        implicitHeight: root.implicitHeight

        GridLayout {
            id: content

            anchors.fill: parent
            anchors.leftMargin: root.theme.drawerContentPadding + box.lip
            anchors.rightMargin: root.theme.drawerContentPadding + box.lip
            anchors.topMargin: root.theme.drawerContentPadding
            anchors.bottomMargin: root.theme.drawerContentPadding
            opacity: box.progress
            columns: 2
            columnSpacing: root.theme.networkDrawerColumnSpacing
            rowSpacing: root.theme.networkDrawerContentSpacing

            ModuleText {
                theme: root.theme
                text: "Network"
                font.pixelSize: root.theme.titleSize
                font.italic: true
                Layout.columnSpan: 2
                Layout.fillWidth: true
            }

            Repeater {
                model: [
                    { text: "IP", isLabel: true },
                    { text: `${root.networkModule.ipAddress}${root.networkModule.cidr ? ` /${root.networkModule.cidr}` : ""}`, isLabel: false },
                    { text: "GW", isLabel: true },
                    { text: root.networkModule.gateway, isLabel: false },
                    { text: "DNS", isLabel: true },
                    { text: root.networkModule.dns, isLabel: false }
                ]

                delegate: ModuleText {
                    required property var modelData

                    theme: root.theme
                    text: modelData.text
                    color: modelData.isLabel ? root.theme.palette5 : root.theme.fg
                    font.pixelSize: root.theme.cpuDrawerFontSize
                    wrapMode: Text.WrapAnywhere
                    horizontalAlignment: Text.AlignLeft
                    Layout.row: Math.floor(index / 2) + 1
                    Layout.column: index % 2
                    Layout.fillWidth: !modelData.isLabel
                }
            }
        }
    }

    HoverHandler {
        onHoveredChanged: hovered ? root.entered() : root.exited()
    }

    signal entered
    signal exited

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
}
