import QtQuick
import Quickshell.Io

Item {
    id: root

    required property var theme

    property bool showGb: false
    property string percentUsage: "--%"
    property string gbUsage: "--GB / --GB"

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    ModuleText {
        id: label

        theme: root.theme
        text: "  " + (root.showGb ? root.gbUsage : root.percentUsage)
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.showGb = !root.showGb
    }

    Process {
        running: true

        command: ["bash", "-c", `
while true; do
  awk '
    /MemTotal/ { total=$2 }
    /MemAvailable/ { available=$2 }
    END {
      used=total-available
      percent=int(used*100/total)

      used_gb=used/1024/1024

      printf "%d%%|%.1fGB\\n", percent, used_gb
    }
  ' /proc/meminfo

  sleep 1
done
        `]

        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split("|");

                root.percentUsage = parts[0] || "--%";
                root.gbUsage = parts[1] || "q--GB";
            }
        }
    }
}
