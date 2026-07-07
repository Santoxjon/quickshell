import QtQuick
import Quickshell
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
        command: ["bash", Quickshell.shellDir + "/scripts/get-memory-usage.sh"]

        stdout: SplitParser {
            onRead: data => {
                const mem = JSON.parse(data);

                root.percentUsage = mem.percentUsage;
                root.gbUsage = mem.gbUsage;
            }
        }
    }
}
