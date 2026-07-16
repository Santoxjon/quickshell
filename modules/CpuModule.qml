import QtQuick

import qs.components

Item {
    id: root

    required property var theme
    required property var cpuUsage

    signal hovered
    signal unhovered

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    Row {
        id: content
        spacing: root.theme.moduleSpacing

        ModuleText {
            theme: root.theme
            text: ""
            color: root.theme.rightModuleIcon
        }

        ModuleText {
            theme: root.theme
            text: root.cpuUsage.usageText
            color: root.theme.fg
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton

        onEntered: root.hovered()
        onExited: root.unhovered()
    }
}
