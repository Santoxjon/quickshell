import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    required property var theme

    property string network: "󰈀 --"

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    ModuleText {
        id: label

        theme: root.theme
        text: network
    }

    Process {
        running: true
        command: ["bash", Quickshell.shellDir + "/scripts/get-network-ip.sh"]

        stdout: SplitParser {
            onRead: data => root.network = data.trim()
        }
    }
}
