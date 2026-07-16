import QtQuick
import Quickshell

import qs.components
import qs.services

Item {
    id: root

    required property var theme

    property string temperatureText: "--°C"

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    Row {
        id: content
        spacing: root.theme.moduleSpacing

        ModuleText {
            theme: root.theme
            text: ""
            color: root.theme.rightModuleIcon
        }

        ModuleText {
            theme: root.theme
            color: root.theme.fg
            text: root.temperatureText
        }
    }

    LineProcess {
        logName: "CPU temperature"
        running: true
        command: [Quickshell.shellDir + "/scripts/get-cpu-temp.sh"]

        onLineReceived: line => root.temperatureText = line.trim() || "--°C"
    }
}
