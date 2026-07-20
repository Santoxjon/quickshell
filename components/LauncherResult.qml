pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Widgets

Rectangle {
    id: root

    required property var theme
    required property DesktopEntry application
    property bool selected: false

    readonly property bool hovered: pointerArea.containsMouse

    signal activated
    signal pointerEntered
    signal wheelScrolled(real delta)

    radius: root.theme.launcherResultRadius
    color: root.selected ? root.theme.launcherResultSelectedBg : root.theme.launcherResultBg
    opacity: root.hovered || root.selected ? 1 : root.theme.launcherResultOpacity
    border.width: root.theme.thinBorderWidth
    border.color: root.theme.border

    Behavior on color {
        ColorAnimation {
            duration: root.theme.fastAnimationDuration
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: root.theme.fastAnimationDuration
            easing.type: Easing.OutCubic
        }
    }

    IconImage {
        id: applicationIcon

        anchors.left: parent.left
        anchors.leftMargin: root.theme.launcherResultHorizontalPadding
        anchors.verticalCenter: parent.verticalCenter

        width: root.theme.launcherResultIconSize
        height: width

        source: Quickshell.iconPath(root.application.icon, true)
        asynchronous: true
        mipmap: true
    }

    Text {
        anchors.centerIn: applicationIcon
        visible: applicationIcon.status === Image.Error || applicationIcon.status === Image.Null

        text: ""
        textFormat: Text.PlainText
        color: root.theme.fg
        font.family: root.theme.fontName
        font.pixelSize: root.theme.launcherResultIconSize - 8
    }

    Column {
        anchors.left: applicationIcon.right
        anchors.leftMargin: root.theme.launcherResultTextSpacing
        anchors.right: parent.right
        anchors.rightMargin: root.theme.launcherResultHorizontalPadding
        anchors.verticalCenter: parent.verticalCenter

        spacing: 1

        Text {
            width: parent.width

            text: root.application.name
            textFormat: Text.PlainText
            color: root.theme.fg
            elide: Text.ElideRight
            font.family: root.theme.fontName
            font.pixelSize: root.theme.titleSize
            font.weight: Font.Bold
        }

        Text {
            width: parent.width

            visible: text.length > 0
            text: root.application.genericName || root.application.comment || ""
            textFormat: Text.PlainText
            color: root.theme.palette3
            elide: Text.ElideRight
            font.family: root.theme.fontName
            font.pixelSize: root.theme.captionFontSize
        }
    }

    MouseArea {
        id: pointerArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: root.activated()
        onEntered: root.pointerEntered()

        onWheel: wheel => {
            const wheelDelta = wheel.angleDelta.y !== 0 ? wheel.angleDelta.y : wheel.pixelDelta.y;

            root.wheelScrolled(wheelDelta);
            wheel.accepted = true;
        }
    }
}
