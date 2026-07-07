import QtQuick

Text {
    required property var theme

    color: theme.fg
    font.family: theme.fontName
    font.pixelSize: theme.fontSize
    font.weight: Font.ExtraBold
}
