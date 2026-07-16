import QtQuick

QtObject {
    // Base palette
    readonly property color palette0: "#e4d6a9"
    readonly property color palette1: "#c3a97c"
    readonly property color palette2: "#a37d54"
    readonly property color palette3: "#835331"
    readonly property color palette4: "#622b14"
    readonly property color palette5: "#4d1f0f"
    readonly property color palette6: "#3a170b"

    // Semantic colors
    readonly property color bg: palette0
    readonly property color fg: palette4
    readonly property color border: palette4
    readonly property color activeBg: palette4
    readonly property color activeFg: palette0
    readonly property color rightModuleIcon: palette5
    readonly property color separator: palette2
    readonly property color shutdownButton: palette6
    readonly property color lockFlyoutBg: palette2

    // Typography
    readonly property string fontName: "JetBrainsMono Nerd Font"
    readonly property int captionFontSize: 13
    readonly property int smallFontSize: 15
    readonly property int fontSize: 17
    readonly property int titleSize: 20

    // Dimensions
    readonly property int barHeight: 28
    readonly property int borderWidth: 2
    readonly property int accentBorderWidth: 3
    readonly property int cornerRadius: 5
    readonly property int moduleSpacing: 8
    readonly property int separatorHorizontalPadding: 6

    // Motion
    readonly property int fastAnimationDuration: 80
    readonly property int animationDuration: 220

    // Top bar
    readonly property color topBarBottomBorder: palette4
    readonly property int topBarContentRightMargin: 5

    // Workspaces
    readonly property int workspaceHorizontalPadding: 12
    readonly property int workspaceVerticalPadding: 4

    // Application indicators
    readonly property int appIndicatorIconSize: 17
    readonly property int appIndicatorSpacing: 8

    // Audio outputs
    readonly property color audioOutputActiveText: palette4
    readonly property color audioOutputText: palette3
    readonly property int audioModuleSpacing: 6
    readonly property int audioModuleIconWidth: 23
    readonly property int audioModuleValueWidth: 42

    // Audio drawer
    readonly property int audioDrawerWidth: 320
    readonly property int audioDrawerDefaultHeight: 300
    readonly property int audioDrawerLip: 18
    readonly property int audioDrawerBorderInset: 1
    readonly property int audioDrawerRightMargin: 30
    readonly property int audioDrawerContentPadding: 12
    readonly property int audioDrawerContentSpacing: 10
    readonly property int audioOutputRowHeight: 26
    readonly property int audioDrawerCloseDelay: animationDuration + 10

    // Volume slider
    readonly property color sliderBg: palette3
    readonly property color sliderEmptyBg: palette1
    readonly property color sliderHandleRectangleBg: palette0
    readonly property color sliderHandleRectangleBorder: palette3
    readonly property int audioSliderHeight: 28
    readonly property int audioSliderTrackHeight: 15
    readonly property int audioSliderHandleWidth: 20
    readonly property int audioSliderHandleHeight: 25
}
