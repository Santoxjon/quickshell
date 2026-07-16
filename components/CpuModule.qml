import QtQuick
import Quickshell

import "../popups"

Item {
    id: root

    required property var theme

    property string usage: "--%"
    property string tooltipText: "CPU"

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
            text: root.usage
            color: root.theme.fg
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
    }

    CpuTooltipPopup {
        theme: root.theme
        anchorItem: root
        isOpen: mouseArea.containsMouse
        text: root.tooltipText
    }

    JsonLineProcess {
        logName: "CPU usage"
        running: true
        command: [Quickshell.shellDir + "/scripts/get-cpu-usage.sh"]

        onJsonReceived: cpu => {
            root.usage = typeof cpu.usage === "string" ? cpu.usage : "--%";
            root.tooltipText = typeof cpu.tooltipText === "string" ? cpu.tooltipText : "CPU";
        }
    }
}
