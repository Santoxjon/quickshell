import QtQuick

import qs.components

Item {
    id: root

    required property var theme

    readonly property string icon: ""

    signal activated

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    ModuleText {
        id: label

        theme: root.theme
        text: root.icon
        color: root.theme.shutdownButton
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: root.activated()
    }
}
