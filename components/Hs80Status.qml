// components/Hs80Status.qml
import QtQuick
import Quickshell.Io

Item {
    id: root

    property bool active: false
    property string batteryText: ""
    property string chargingStatus: ""

    property int chargingFrame: 0

    readonly property int batteryPercentage: parseInt(batteryText, 10) || 0

    readonly property bool charging: chargingStatus === "charging"

    readonly property var chargingIcons: ["󰢟", "󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅",]

    readonly property int chargingStartIndex: {
        if (batteryPercentage <= 10)
            return 0;

        return Math.min(chargingIcons.length - 1, Math.floor(batteryPercentage / 10));
    }

    readonly property int chargingFrameCount: chargingIcons.length - chargingStartIndex

    readonly property string chargingIcon: chargingIcons[chargingStartIndex + chargingFrame]

    readonly property string icon: charging ? chargingIcon : batteryIcon(batteryPercentage)

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
        id: refreshTimer

        interval: 2000
        repeat: true
        running: root.active

        onTriggered: root.refresh()
    }

    Timer {
        id: chargingAnimationTimer

        interval: 750
        repeat: true
        running: root.active && root.charging && root.chargingFrameCount > 1

        onTriggered: {
            chargingFrame++;

            if (chargingFrame >= chargingFrameCount)
                chargingFrame = 0;
        }
    }

    onActiveChanged: {
        if (active) {
            refresh();
        } else {
            chargingFrame = 0;
        }
    }

    onChargingChanged: {
        chargingFrame = 0;
    }

    onChargingStartIndexChanged: {
        chargingFrame = 0;
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
