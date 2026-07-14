import QtQuick
import Quickshell
import Quickshell.Io

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
        spacing: 8

        ModuleText {
            id: icon

            theme: root.theme
            text: ""
            color: root.theme.rightModuleIcon
        }

        ModuleText {
            id: usageLabel

            theme: root.theme
            text: root.usage
            color: root.theme.fg
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    CpuTooltipPopup {
        theme: root.theme
        anchorItem: root
        isOpen: mouseArea.containsMouse
        text: root.tooltipText
    }

    Process {
        running: true
        command: ["bash", Quickshell.shellDir + "/scripts/get-cpu-usage.sh"]

        stdout: SplitParser {
            onRead: data => {
                const cpu = JSON.parse(data);

                root.usage = cpu.usage;
                root.tooltipText = cpu.tooltipText;
            }
        }
    }
}
