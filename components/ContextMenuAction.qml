pragma ComponentBehavior: Bound

import QtQuick

Rectangle {
    id: root

    required property var theme
    required property string label
    property bool actionEnabled: true

    signal triggered

    implicitWidth: root.theme.appIndicatorMenuWidth - 2 * root.theme.appIndicatorMenuPadding
    implicitHeight: root.theme.appIndicatorMenuItemHeight
    radius: root.theme.appIndicatorMenuItemRadius
    color: actionMouseArea.containsMouse && root.actionEnabled ? root.theme.activeBg : "transparent"
    opacity: root.actionEnabled ? 1 : 0.45

    ModuleText {
        anchors.fill: parent
        anchors.leftMargin: root.theme.appIndicatorMenuItemHorizontalPadding
        anchors.rightMargin: root.theme.appIndicatorMenuItemHorizontalPadding

        theme: root.theme
        text: root.label
        color: actionMouseArea.containsMouse && root.actionEnabled ? root.theme.activeFg : root.theme.fg
        font.pixelSize: root.theme.captionFontSize
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    MouseArea {
        id: actionMouseArea

        anchors.fill: parent
        enabled: root.actionEnabled
        hoverEnabled: true
        cursorShape: root.actionEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: root.triggered()
    }
}
