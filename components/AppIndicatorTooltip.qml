import QtQuick
import Quickshell

PopupWindow {
    id: root

    required property var theme
    required property Item anchorItem
    required property string label
    property bool hoverActive: false
    property bool tooltipShown: false

    visible: root.anchorItem.visible && root.tooltipShown
    grabFocus: false
    color: "transparent"
    mask: Region {}

    implicitWidth: tooltipLabel.implicitWidth + 2 * root.theme.tooltipHorizontalPadding
    implicitHeight: tooltipLabel.implicitHeight + 2 * root.theme.tooltipVerticalPadding

    anchor.item: root.anchorItem
    anchor.rect.x: (root.anchorItem.width - root.implicitWidth) / 2
    anchor.rect.y: (root.theme.barHeight + root.anchorItem.height) / 2 + root.theme.tooltipOffset
    anchor.adjustment: PopupAdjustment.SlideX

    function beginHover(): void {
        root.hoverActive = true;
        showTimer.restart();
    }

    function endHover(): void {
        root.hoverActive = false;
        showTimer.stop();
        root.tooltipShown = false;
    }

    function dismiss(): void {
        root.endHover();
    }

    Timer {
        id: showTimer

        interval: root.theme.tooltipDelay
        repeat: false

        onTriggered: {
            if (root.hoverActive)
                root.tooltipShown = true;
        }
    }

    Rectangle {
        anchors.fill: parent

        radius: root.theme.tooltipCornerRadius
        color: root.theme.bg
        border.width: root.theme.thinBorderWidth
        border.color: root.theme.border

        ModuleText {
            id: tooltipLabel

            anchors.centerIn: parent
            theme: root.theme
            text: root.label
            font.pixelSize: root.theme.captionFontSize
        }
    }
}
