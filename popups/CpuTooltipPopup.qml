import QtQuick
import Quickshell

PopupWindow {
    id: root

    required property var theme
    required property var anchorItem

    property bool isOpen: false
    property string text: "CPU"

    visible: root.isOpen
    color: "transparent"

    anchor.item: root.anchorItem
    anchor.rect.x: 0
    anchor.rect.y: root.anchorItem.height + 6

    height: box.height
    width: box.width

    Rectangle {
        id: box

        width: tooltipText.implicitWidth + 24
        height: tooltipText.implicitHeight + 18

        color: root.theme.activeBg
        border.color: root.theme.fg
        radius: 4

        Text {
            id: tooltipText

            anchors.centerIn: parent
            text: root.text

            color: root.theme.activeFg
            font.family: root.theme.fontName
            font.pixelSize: 15
            font.weight: Font.Bold
            lineHeight: 1.25
        }
    }
}
