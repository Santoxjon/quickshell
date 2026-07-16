pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Row {
    id: root

    required property var theme
    property var activeApplications: []
    readonly property var supportedApplications: ["discord", "steam"]

    anchors.verticalCenter: parent.verticalCenter
    height: root.theme.appIndicatorIconSize
    spacing: root.theme.appIndicatorSpacing

    function updateActiveApplications(line: string): void {
        const state = line.trim();

        root.activeApplications = state.length > 0 ? state.split(/\s+/) : [];
    }

    Repeater {
        model: root.supportedApplications

        delegate: Image {
            required property string modelData

            anchors.verticalCenter: parent.verticalCenter
            visible: root.activeApplications.includes(modelData)
            width: root.theme.appIndicatorIconSize
            height: width
            sourceSize: Qt.size(width, height)
            fillMode: Image.PreserveAspectFit
            source: Quickshell.shellDir + "/assets/" + modelData + ".png"
        }
    }

    Process {
        running: true
        command: [Quickshell.shellDir + "/scripts/app-indicator.sh"]

        stdout: SplitParser {
            onRead: line => root.updateActiveApplications(line)
        }
        stderr: SplitParser {
            onRead: line => console.warn(`Application indicator: ${line}`)
        }
    }
}
