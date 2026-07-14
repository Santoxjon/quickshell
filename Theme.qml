import QtQuick

QtObject {
    // Color palette:
    readonly property color palette0: "#e4d6a9"
    readonly property color palette1: "#c3a97c"
    readonly property color palette2: "#a37d54"
    readonly property color palette3: "#835331"
    readonly property color palette4: "#622b14"
    readonly property color palette5: "#4d1f0f"
    readonly property color palette6: "#3a170b"

    property color bg: palette0
    property color fg: palette4
    property color rightModuleIcon: palette5
    property color activeBg: palette4
    property color activeFg: palette0
    property color border: palette4

    // Topbar
    property color topBarBottomBorder: palette4

    property string fontName: "JetBrainsMono Nerd Font"
    property int fontSize: 17
    property int titleSize: 20
    property int barHeight: 28

    //Audio Module
    property color audioOutputActiveText: palette4
    property color audioOutputText: palette3

    // Volume slider
    property color sliderBg: palette3
    property color sliderEmptyBg: palette1
    property color sliderHandleRectangleBg: palette0
    property color sliderHandleRectangleBorder: palette3
    property color separator: palette2
    property color shutdownButton: palette6
}
