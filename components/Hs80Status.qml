// components/Hs80Status.qml
import QtQuick
import Quickshell.Io

Item {
    id: root

    property bool active: false
    property string batteryText: ""
    property string chargingStatus: ""

    readonly property int batteryPercentage: parseInt(batteryText, 10) || 0

    readonly property bool charging: chargingStatus === "charging"

    readonly property string icon: charging ? "󰂄" : batteryIcon(batteryPercentage)

    visible: false
    width: 0
    height: 0

    Process {
        id: batteryProcess
        command: ["cat", "/run/hs80-battery"]

        stdout: SplitParser {
            onRead: line => root.batteryText = line.trim()
        }
    }

    Process {
        id: chargingProcess
        command: ["cat", "/run/hs80-charging"]

        stdout: SplitParser {
            onRead: line => root.chargingStatus = line.trim()
        }
    }

    Timer {
        interval: 2000
        repeat: true
        running: root.active

        onTriggered: root.refresh()
    }

    onActiveChanged: {
        if (active)
            refresh();
    }

    function refresh() {
        if (!batteryProcess.running)
            batteryProcess.running = true;

        if (!chargingProcess.running)
            chargingProcess.running = true;
    }

    function batteryIcon(percentage) {
        if (percentage >= 91)
            return "󰁹";
        if (percentage >= 81)
            return "󰂂";
        if (percentage >= 71)
            return "󰂁";
        if (percentage >= 61)
            return "󰂀";
        if (percentage >= 51)
            return "󰁿";
        if (percentage >= 41)
            return "󰁾";
        if (percentage >= 31)
            return "󰁽";
        if (percentage >= 21)
            return "󰁼";
        if (percentage >= 11)
            return "󰁻";

        return "󰂃";
    }
}
