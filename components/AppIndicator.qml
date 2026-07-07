import QtQuick
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

        command: ["bash", "-c", `
get_state() {
  hyprctl clients -j | jq -r '
    [.[].class | ascii_downcase] |
    [
      if any(.[]; test("discord|vesktop|legcord")) then "discord" else empty end,
      if any(.[]; test("steam")) then "steam" else empty end
    ] | join(" ")
  '
}

get_state

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

socat -U - UNIX-CONNECT:"$SOCKET" | while read -r event; do
  case "$event" in
    openwindow*|closewindow*|movewindow*|workspace*)
      get_state
      ;;
  esac
done
        `]

        stdout: SplitParser {
            onRead: data => root.setState(data)
        }
    }
}
