import QtQuick
import Quickshell
import Quickshell.Io

Row {
    id: root

    required property var theme

    height: parent.height
    spacing: 8

    property bool discordOpen: false
    property bool steamOpen: false

    function setState(line) {
        const parts = line.trim().split(" ");
        root.discordOpen = parts.includes("discord");
        root.steamOpen = parts.includes("steam");
    }

    Image {
        visible: root.discordOpen
        width: 17
        height: 17
        sourceSize.width: 17
        sourceSize.height: 17
        fillMode: Image.PreserveAspectFit
        source: "/home/jon/.config/quickshell/assets/discord.png"
        anchors.verticalCenter: parent.verticalCenter
    }

    Image {
        visible: root.steamOpen
        width: 17
        height: 17
        sourceSize.width: 17
        sourceSize.height: 17
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        source: "/home/jon/.config/quickshell/assets/steam.png"
    }

    Process {
        running: true
        command: ["bash", Quickshell.shellDir + "/scripts/app-indicator.sh"]

        stdout: SplitParser {
            onRead: line => root.setState(line)
        }
        stderr: SplitParser {
            onRead: line => console.log("app-indicator error:", line)
        }
    }
}
