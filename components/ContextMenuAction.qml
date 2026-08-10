pragma ComponentBehavior: Bound

import QtQuick

Rectangle {
    id: root

    required property var theme
    required property string label
    property string trailingText: ""
    property bool actionEnabled: true
    property bool dimWhenDisabled: true
    property real availableWidth: root.theme.appIndicatorMenuWidth
    readonly property bool highlighted: root.actionEnabled && actionMouseArea.containsMouse

    signal triggered

    implicitWidth: root.availableWidth - 2 * root.theme.appIndicatorMenuPadding
    implicitHeight: root.theme.appIndicatorMenuItemHeight
    radius: root.theme.appIndicatorMenuItemRadius
    color: root.highlighted ? root.theme.activeBg : "transparent"
    opacity: root.actionEnabled || !root.dimWhenDisabled ? 1 : 0.45

    ModuleText {
        id: actionLabel

        anchors.fill: parent
        anchors.leftMargin: root.theme.appIndicatorMenuItemHorizontalPadding
        anchors.rightMargin: root.theme.appIndicatorMenuItemHorizontalPadding
            + (trailingLabel.visible ? trailingLabel.implicitWidth + root.theme.appIndicatorMenuItemHorizontalPadding : 0)

        theme: root.theme
        text: root.label
        color: root.highlighted ? root.theme.activeFg : root.theme.fg
        font.pixelSize: root.theme.captionFontSize
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    ModuleText {
        id: trailingLabel

        visible: root.trailingText.length > 0
        anchors.right: parent.right
        anchors.rightMargin: root.theme.appIndicatorMenuItemHorizontalPadding
        anchors.verticalCenter: parent.verticalCenter

        theme: root.theme
        text: root.trailingText
        color: root.highlighted ? root.theme.activeFg : root.theme.fg
        font.pixelSize: root.theme.captionFontSize
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
