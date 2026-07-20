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
    readonly property color palette7: "#0f0502"

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
    readonly property int thinBorderWidth: 1
    readonly property int borderWidth: 2
    readonly property int accentBorderWidth: 3
    readonly property int cornerRadius: 5
    readonly property int moduleSpacing: 8
    readonly property int separatorHorizontalPadding: 6

    // Motion
    readonly property int fastAnimationDuration: 80
    readonly property int animationDuration: 220

    // Application launcher
    readonly property color launcherVeilColor: palette7
    readonly property real launcherVeilOpacity: 0.8
    readonly property color launcherInputBg: "#fffeee"
    readonly property color launcherInputFg: palette5
    readonly property color launcherInputPlaceholder: palette5
    readonly property color launcherInputShadow: "#fffeee"
    readonly property real launcherInputShadowOpacity: 0.35
    readonly property real launcherInputShadowBlur: 0.7
    readonly property color launcherResultBg: palette1
    readonly property color launcherResultSelectedBg: palette0
    readonly property real launcherResultOpacity: 0.9
    readonly property int launcherWidth: 800
    readonly property int launcherInputHeight: 82
    readonly property int launcherInputHorizontalPadding: 26
    readonly property int launcherInputFontSize: 32
    readonly property int launcherInputRadius: 12
    readonly property int launcherInputActiveOffset: 250
    readonly property int launcherResultsTopMargin: 24
    readonly property int launcherResultsRevealOffset: 18
    readonly property int launcherResultHeight: 72
    readonly property int launcherResultSpacing: 10
    readonly property int launcherResultHorizontalPadding: 18
    readonly property int launcherResultIconSize: 42
    readonly property int launcherResultTextSpacing: 16
    readonly property int launcherResultRadius: 8
    readonly property int launcherMaxResults: 6
    readonly property color launcherScrollbar: "#fffeee"
    readonly property int launcherScrollbarWidth: 10
    readonly property int launcherScrollbarGap: 10
    readonly property int launcherScrollStep: 30
    readonly property int launcherBottomShadowHeight: 70
    readonly property int launcherBottomShadowFadeDistance: launcherResultHeight + launcherResultSpacing
    readonly property color launcherBottomShadowColor: palette7
    readonly property real launcherBottomShadowOpacity: 0.75
    readonly property real launcherClosedScale: 0.96

    // Power menu
    readonly property color powerMenuVeilColor: palette7
    readonly property real powerMenuVeilOpacity: 0.9
    readonly property real powerMenuCountdownVeilOpacity: 1.0
    readonly property color powerMenuActionColor: palette0
    readonly property int powerMenuMaxWidth: 1500
    readonly property int powerMenuHorizontalMargin: 80
    readonly property int powerMenuButtonSize: 220
    readonly property int powerMenuTextSpacing: 42
    readonly property int powerMenuTextSize: 30
    readonly property real powerMenuClosedScale: 0.88
    readonly property real powerMenuHoverScale: 1.1
    readonly property real powerMenuHiddenScale: 0.72
    readonly property real powerMenuShadowOpacity: 0.9
    readonly property real powerMenuShadowBlur: 0.8
    readonly property int powerMenuCountdownSeconds: 9
    readonly property int powerMenuIdleTimeout: 20000

    // Tooltips
    readonly property int tooltipOffset: 6
    readonly property int tooltipHorizontalPadding: 12
    readonly property int tooltipVerticalPadding: 9
    readonly property int tooltipCornerRadius: 4
    readonly property real tooltipLineHeight: 1.25

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

    // Drawers
    readonly property int drawerLip: 18
    readonly property int drawerBorderInset: 1
    readonly property int drawerContentPadding: 12
    readonly property int drawerCloseDelay: animationDuration + 10

    // Audio drawer
    readonly property int audioDrawerWidth: 320
    readonly property int audioDrawerRightMargin: 30
    readonly property int audioDrawerContentSpacing: 10
    readonly property int audioOutputRowHeight: 26

    // CPU drawer
    readonly property color cpuDrawerGridSeparator: palette2
    readonly property color cpuDrawerCoreName: palette5
    readonly property int cpuDrawerFontSize: smallFontSize
    readonly property int cpuDrawerCellWidth: 124
    readonly property int cpuDrawerCellHeight: 26
    readonly property int cpuDrawerColumnSpacing: 8
    readonly property int cpuDrawerRowSpacing: 10
    readonly property int cpuDrawerLabelSpacing: 6

    // Volume slider
    readonly property color sliderBg: palette3
    readonly property color sliderEmptyBg: palette1
    readonly property color sliderHandleRectangleBg: palette0
    readonly property color sliderHandleRectangleBorder: palette3
    readonly property int audioSliderHeight: 28
    readonly property int audioSliderTrackHeight: 15
    readonly property int audioSliderHandleWidth: 20
    readonly property int audioSliderHandleHeight: 25

    // Volume flyout
    readonly property int volumeFlyoutPanelHeight: 84
    readonly property int volumeFlyoutWidth: 325
    readonly property int volumeFlyoutHeight: 40
    readonly property int volumeFlyoutRadius: 30
    readonly property real volumeFlyoutOpacity: 0.9
    readonly property int volumeFlyoutHiddenOffset: 16
    readonly property int volumeFlyoutHorizontalPadding: 18
    readonly property int volumeFlyoutSpacing: 14
    readonly property int volumeFlyoutBarWidth: 245
    readonly property int volumeFlyoutBarRadius: 3
    readonly property int volumeFlyoutDisplayDuration: 1000

    // Keyboard lock flyouts
    readonly property int lockFlyoutBottomMargin: 100
    readonly property int lockFlyoutPanelHeight: 150
    readonly property int lockFlyoutSize: 120
    readonly property int lockFlyoutRadius: 20
    readonly property real lockFlyoutOpacity: 0.9
    readonly property int lockFlyoutHiddenOffset: 16
    readonly property int lockFlyoutIconSize: 100

    // Notifications
    readonly property int notificationScreenMargin: 12
    readonly property int notificationTopOffset: 40
    readonly property int notificationGap: 10
    readonly property int notificationWidth: 360
    readonly property int notificationAccentWidth: 7
    readonly property int notificationContentPadding: 8
    readonly property int notificationContentLeftPadding: 15
    readonly property int notificationContentSpacing: 16
    readonly property int notificationTextSpacing: 4
    readonly property int notificationIconSize: 96
    readonly property int notificationHiddenOffset: 40
}
