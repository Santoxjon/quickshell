import QtQuick
import Quickshell.Io

Item {
    id: root

    required property var theme

    property string network: "󰈀 --"

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    ModuleText {
        id: label

        theme: root.theme
        text: network
    }

    Process {
        running: true
        command: ["bash", "-c", `
while true; do
  iface=$(ip route | awk '/default/ {print $5; exit}')
  ipaddr=$(ip -4 addr show "$iface" 2>/dev/null | awk '/inet / {print $2; exit}' | cut -d/ -f1)

  [ -z "$ipaddr" ] && ipaddr="--"

  case "$iface" in
    wl*|wlan*) echo "󰖩 $ipaddr" ;;
    en*|eth*)  echo "󰈀 $ipaddr" ;;
    *)         echo "󰈀 $ipaddr" ;;
  esac

  sleep 2
done
        `]

        stdout: SplitParser {
            onRead: data => root.network = data.trim()
        }
    }
}
