import QtQuick
import Quickshell
import Quickshell.Io

import "../popups"

Item {
    id: root

    required property var theme

    property string usage: "--%"

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    property string tooltipText: "CPU"

    ModuleText {
        id: label
        theme: root.theme
        text: "  " + root.usage
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
