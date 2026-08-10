import QtQuick
import Quickshell

import qs.components

ModuleText {
    text: Qt.formatDateTime(clock.date, "HH:mm")

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }
}
