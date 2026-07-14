import QtQuick
import Quickshell.Io

Item {
    id: root

    required property var theme

    property string shutdown: ""

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    ModuleText {
        id: label

        theme: root.theme
        text: root.shutdown
        color: theme.shutdownButton
    }

    MouseArea {
        onClicked: {
            // ! TODO
        }
    }
}
