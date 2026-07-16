pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import qs.components

PopupWindow {
    id: root

    required property var theme
    required property Item anchorItem
    required property var cpuUsage

    property bool opened: false
    property bool animating: false

    readonly property int coreCount: root.cpuUsage.cores.length
    readonly property int columnCount: root.coreCount < 12 ? 2 : root.coreCount < 16 ? 3 : 4
    readonly property int rowCount: Math.ceil(root.coreCount / root.columnCount)
    readonly property real gridWidth: root.columnCount * root.theme.cpuDrawerCellWidth + (root.columnCount - 1) * root.theme.cpuDrawerColumnSpacing
    readonly property real gridHeight: root.rowCount * root.theme.cpuDrawerCellHeight + Math.max(0, root.rowCount - 1) * root.theme.cpuDrawerRowSpacing
    readonly property bool fullyOpened: box.fullyOpened

    signal entered
    signal exited

    visible: root.opened || root.animating
    color: "transparent"
    implicitWidth: root.gridWidth + (root.theme.drawerContentPadding + root.theme.drawerLip) * 2
    implicitHeight: Math.max(root.theme.cpuDrawerCellHeight, root.gridHeight) + root.theme.drawerContentPadding * 2

    anchor.item: root.anchorItem
    anchor.rect.x: (root.anchorItem.width - root.implicitWidth) / 2
    anchor.rect.y: (root.theme.barHeight + root.anchorItem.height) / 2 - root.theme.accentBorderWidth

    DrawerBackground {
        id: box

        theme: root.theme
        opened: root.opened
        implicitHeight: root.implicitHeight

        Item {
            id: grid

            anchors.top: parent.top
            anchors.topMargin: root.theme.drawerContentPadding
            anchors.horizontalCenter: parent.horizontalCenter
            width: root.gridWidth
            height: root.gridHeight
            opacity: box.height / root.implicitHeight

            Grid {
                anchors.fill: parent
                columns: root.columnCount
                columnSpacing: root.theme.cpuDrawerColumnSpacing
                rowSpacing: root.theme.cpuDrawerRowSpacing

                Repeater {
                    model: root.cpuUsage.cores

                    delegate: Item {
                        id: coreCell

                        required property var modelData

                        readonly property string coreName: `Core ${coreCell.modelData.id.toString().padStart(2, " ")}:`
                        readonly property string usageText: `${coreCell.modelData.usage.toString().padStart(2, "0")}%`

                        width: root.theme.cpuDrawerCellWidth
                        height: root.theme.cpuDrawerCellHeight

                        Row {
                            anchors.centerIn: parent
                            spacing: root.theme.cpuDrawerLabelSpacing

                            ModuleText {
                                theme: root.theme
                                text: coreCell.coreName
                                color: root.theme.cpuDrawerCoreName
                                font.pixelSize: root.theme.cpuDrawerFontSize
                            }

                            ModuleText {
                                theme: root.theme
                                text: coreCell.usageText
                                font.pixelSize: root.theme.cpuDrawerFontSize
                            }
                        }
                    }
                }
            }

            Repeater {
                model: Math.max(0, root.columnCount - 1)

                delegate: Rectangle {
                    required property int index

                    x: (index + 1) * root.theme.cpuDrawerCellWidth + index * root.theme.cpuDrawerColumnSpacing + Math.floor((root.theme.cpuDrawerColumnSpacing - width) / 2)
                    width: root.theme.thinBorderWidth
                    height: grid.height
                    color: root.theme.cpuDrawerGridSeparator
                    z: 1
                }
            }

            Repeater {
                model: Math.max(0, root.rowCount - 1)

                delegate: Rectangle {
                    required property int index

                    y: (index + 1) * root.theme.cpuDrawerCellHeight + index * root.theme.cpuDrawerRowSpacing + Math.floor((root.theme.cpuDrawerRowSpacing - height) / 2)
                    width: grid.width
                    height: root.theme.thinBorderWidth
                    color: root.theme.cpuDrawerGridSeparator
                    z: 1
                }
            }
        }

        ModuleText {
            anchors.centerIn: parent
            theme: root.theme
            text: "CPU data unavailable"
            visible: root.coreCount === 0
            opacity: box.height / root.implicitHeight
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
}
