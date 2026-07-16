import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: root

    property bool active: false
    property int chargingFrame: 0

    readonly property string batteryText: batteryFile.loaded ? batteryFile.text().trim() : ""
    readonly property string chargingStatus: chargingFile.loaded ? chargingFile.text().trim() : ""
    readonly property int batteryPercentage: root.parseBatteryPercentage(root.batteryText)
    readonly property bool charging: root.chargingStatus === "charging"
    readonly property int chargingAnimationInterval: 750
    readonly property var batteryIcons: ["󰂃", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]
    readonly property var chargingIcons: ["󰢟", "󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"]

    readonly property int chargingStartIndex: {
        if (root.batteryPercentage <= 10)
            return 0;

        return Math.min(root.chargingIcons.length - 1, Math.floor(root.batteryPercentage / 10));
    }
    readonly property int chargingFrameCount: root.chargingIcons.length - root.chargingStartIndex
    readonly property string chargingIcon: root.chargingIcons[root.chargingStartIndex + root.chargingFrame]
    readonly property string icon: root.charging ? root.chargingIcon : root.batteryIcon(root.batteryPercentage)

    function parseBatteryPercentage(value: string): int {
        const percentage = parseInt(value, 10);

        return Number.isNaN(percentage) ? 0 : Math.max(0, Math.min(100, percentage));
    }

    function batteryIcon(percentage: int): string {
        const index = Math.max(0, Math.min(root.batteryIcons.length - 1, Math.floor((percentage - 1) / 10)));

        return root.batteryIcons[index];
    }

    FileView {
        id: batteryFile

        path: "/run/hs80-battery"
        preload: root.active
        watchChanges: root.active
        printErrors: false

        onFileChanged: batteryFile.reload()
    }

    FileView {
        id: chargingFile

        path: "/run/hs80-charging"
        preload: root.active
        watchChanges: root.active
        printErrors: false

        onFileChanged: chargingFile.reload()
    }

    Timer {
        interval: root.chargingAnimationInterval
        repeat: true
        running: root.active && root.charging && root.chargingFrameCount > 1

        onTriggered: root.chargingFrame = (root.chargingFrame + 1) % root.chargingFrameCount
    }

    onActiveChanged: {
        if (!root.active)
            root.chargingFrame = 0;
    }

    onChargingChanged: root.chargingFrame = 0

    onChargingStartIndexChanged: root.chargingFrame = 0
}
