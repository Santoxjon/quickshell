import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    required property var theme

    property bool showGb: false
    property string percentUsage: "--%"
    property string gbUsage: "--GB / --GB"

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    Row {
        id: content
        spacing: 8

        ModuleText {
            id: icon

            theme: root.theme
            text: ""
            color: root.theme.rightModuleIcon
        }

        ModuleText {
            id: usageLabel

            theme: root.theme
            text: (root.showGb ? root.gbUsage : root.percentUsage)
            color: root.theme.fg
        }
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
