import QtQuick

Text {
    id: root

    required property var theme

    color: root.theme.fg
    textFormat: Text.PlainText

    font {
        family: root.theme.fontName
        pixelSize: root.theme.fontSize
        weight: Font.ExtraBold
    }
}
