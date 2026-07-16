import QtQuick
import Quickshell

Item {
    id: root

    required property var theme

    property string ipAddress: "--"

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Row {
        id: row
        spacing: root.theme.moduleSpacing

        ModuleText {
            theme: root.theme
            text: "󰈀"
            color: root.theme.rightModuleIcon
        }

        ModuleText {
            theme: root.theme
            text: root.ipAddress
            color: root.theme.fg
        }
    }

    LineProcess {
        logName: "Network address"
        running: true
        command: [Quickshell.shellDir + "/scripts/get-network-ip.sh"]

        onLineReceived: line => root.ipAddress = line.trim() || "--"
    }
}
