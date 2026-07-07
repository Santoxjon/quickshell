import QtQuick
import Quickshell.Io

Item {
    id: root

    required property var theme

    property string temp: "--°C"

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    ModuleText {
        id: label

        theme: root.theme
        text: " " + temp
    }

    Process {
        running: true
        command: ["bash", "-c", `
while true; do
  temp=$(sensors 2>/dev/null | awk '
    /^Package id 0:/ {
      gsub(/[+°C]/, "", $4)
      printf "%d°C", $4
      exit
    }
  ')

  [ -z "$temp" ] && temp="--°C"
  echo "$temp"
  sleep 2
done
        `]

        stdout: SplitParser {
            onRead: data => root.temp = data.trim()
        }
    }
}
