import QtQuick
import Quickshell

import qs.components
import qs.services

Item {
    id: root

    required property var theme

    property string ipAddress: "--"
    property string cidr: ""
    property string gateway: "--"
    property string dns: "--"

    signal hovered
    signal unhovered

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

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton

        onEntered: root.hovered()
        onExited: root.unhovered()
    }

    LineProcess {
        logName: "Network information"
        running: true
        command: [Quickshell.shellDir + "/scripts/get-network-info.sh"]

        onLineReceived: line => {
            const fields = line.trim().split("|");
            if (fields.length !== 4)
                return;

            root.ipAddress = fields[0] || "--";
            root.cidr = fields[1] || "";
            root.gateway = fields[2] || "--";
            root.dns = fields[3] || "--";
        }
    }
}
