import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: root

    required property string unitName
    property int refreshInterval: 1000
    property string activeState: "unknown"

    readonly property bool active: root.activeState === "active"

    function refresh(): void {
        if (!statusProcess.running)
            statusProcess.running = true;
    }

    Component.onCompleted: root.refresh()

    Timer {
        interval: root.refreshInterval
        running: true
        repeat: true

        onTriggered: root.refresh()
    }

    Process {
        id: statusProcess

        command: ["systemctl", "show", root.unitName, "--property=ActiveState", "--value"]

        stdout: StdioCollector {
            onStreamFinished: {
                const state = text.trim();
                root.activeState = state.length > 0 ? state : "unknown";
            }
        }

        stderr: SplitParser {
            onRead: line => console.warn(`Systemd unit ${root.unitName}: ${line}`)
        }

        onExited: function (exitCode) {
            if (exitCode !== 0)
                root.activeState = "unknown";
        }
    }
}
