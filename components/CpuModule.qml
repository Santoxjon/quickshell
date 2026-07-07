import QtQuick
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

        command: ["bash", "-c", `
while true; do
  mpstat -P ALL 1 1 | awk '
    /^Average:/ {
      idle = $NF
      gsub(",", ".", idle)
      usage = int(100 - idle)

      if ($2 == "all") {
        main = usage "%"
      }

      if ($2 ~ /^[0-9]+$/) {
        if (cores != "")
          cores = cores ";"

        cores = cores sprintf("Core %2d: %3d%%", $2, usage)
      }
    }

    END {
      printf "%s|%s\\n", main, cores
    }
  '

  sleep 1
done
    `]

        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split("|");

                root.usage = parts[0] || "--%";
                root.tooltipText = (parts[1] || "CPU").split(";").join("\n").trim();
            }
        }
    }
}
