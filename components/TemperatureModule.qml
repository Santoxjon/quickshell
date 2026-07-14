import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    required property var theme

    property string temp: "--°C"

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    Row {
        id: content
        spacing: 8

        ModuleText {
            id: icon

            theme: root.theme
            text: ""
            color: root.theme.rightModuleIcon
        }

        ModuleText {
            id: label

            theme: root.theme
            color: root.theme.fg
            text: root.temp
        }
    }

    Process {
        running: true
        command: ["bash", Quickshell.shellDir + "/scripts/get-cpu-temp.sh"]

        stdout: SplitParser {
            onRead: data => root.temp = data.trim()
        }
    }
}
