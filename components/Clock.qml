import QtQuick

ModuleText {
    id: root

    property date currentTime: new Date()

    text: Qt.formatDateTime(root.currentTime, "HH:mm")

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: root.currentTime = new Date()
    }
}
