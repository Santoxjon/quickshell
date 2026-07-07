import QtQuick

Text {
    id: root

    required property var theme

    color: theme.fg
    font.family: theme.fontName
    font.pixelSize: theme.fontSize
    font.weight: Font.ExtraBold

    text: Qt.formatDateTime(new Date(), "HH:mm")

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.text = Qt.formatDateTime(new Date(), "HH:mm")
    }
}
