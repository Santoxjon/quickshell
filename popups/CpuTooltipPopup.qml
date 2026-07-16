import QtQuick
import Quickshell

import "../components"

PopupWindow {
    id: root

    required property var theme
    required property Item anchorItem

    property bool isOpen: false
    property string text: "CPU"

    visible: root.isOpen
    color: "transparent"

    anchor.item: root.anchorItem
    anchor.rect.x: 0
    anchor.rect.y: root.anchorItem.height + root.theme.tooltipOffset

    implicitWidth: box.implicitWidth
    implicitHeight: box.implicitHeight

    Rectangle {
        id: box

        anchors.fill: parent
        implicitWidth: tooltipText.implicitWidth + root.theme.tooltipHorizontalPadding * 2
        implicitHeight: tooltipText.implicitHeight + root.theme.tooltipVerticalPadding * 2
        color: root.theme.activeBg
        border.width: root.theme.thinBorderWidth
        border.color: root.theme.fg
        radius: root.theme.tooltipCornerRadius

        ModuleText {
            id: tooltipText

            anchors.centerIn: parent
            theme: root.theme
            text: root.text
            color: root.theme.activeFg
            font.pixelSize: root.theme.smallFontSize
            font.weight: Font.Bold
            lineHeight: root.theme.tooltipLineHeight
        }
    }
}
