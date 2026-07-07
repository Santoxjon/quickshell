import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    required property var theme

    property string temp: "--°C"

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    ModuleText {
        id: label

        theme: root.theme
        text: " " + temp
    }

    Process {
        running: true
        command: ["bash", Quickshell.shellDir + "/scripts/get-cpu-temp.sh"]

        stdout: SplitParser {
            onRead: data => root.temp = data.trim()
        }
    }
}
