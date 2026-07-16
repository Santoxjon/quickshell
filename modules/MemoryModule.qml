import QtQuick
import Quickshell

import qs.components
import qs.services

Item {
    id: root

    required property var theme

    property bool showGigabytes: false
    property string percentageUsage: "--%"
    property string gigabyteUsage: "--GB / --GB"

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    Row {
        id: content
        spacing: root.theme.moduleSpacing

        ModuleText {
            theme: root.theme
            text: ""
            color: root.theme.rightModuleIcon
        }

        ModuleText {
            theme: root.theme
            text: root.showGigabytes ? root.gigabyteUsage : root.percentageUsage
            color: root.theme.fg
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: root.showGigabytes = !root.showGigabytes
    }

    JsonLineProcess {
        logName: "Memory usage"
        running: true
        command: [Quickshell.shellDir + "/scripts/get-memory-usage.sh"]

        onJsonReceived: memory => {
            root.percentageUsage = typeof memory.percentUsage === "string" ? memory.percentUsage : "--%";
            root.gigabyteUsage = typeof memory.gbUsage === "string" ? memory.gbUsage : "--GB / --GB";
        }
    }
}
