import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    required property var theme

    property string network: " --"

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Row {
        id: row
        spacing: 8

        ModuleText {
            id: icon

            theme: root.theme
            text: "󰈀"
            color: root.theme.rightModuleIcon
        }

        ModuleText {
            id: label

            theme: root.theme
            text: root.network
            color: root.theme.fg
        }
    }

    Process {
        running: true
        command: ["bash", Quickshell.shellDir + "/scripts/get-network-ip.sh"]

        stdout: SplitParser {
            onRead: data => root.network = data.trim()
        }
    }
}
