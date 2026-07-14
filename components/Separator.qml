import QtQuick

Text {
    required property var theme

    text: "|"
    color: theme.separator
    font.family: theme.fontName
    font.pixelSize: theme.fontSize

    leftPadding: 6
    rightPadding: 6

    font.weight: Font.ExtraBold
}
