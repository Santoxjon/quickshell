import QtQuick
import Quickshell

PanelWindow {
    id: root

    required property var theme
    required property string enabledIcon
    required property string disabledIcon
    property bool lockEnabled: false
    property bool opened: false
    property int displayDuration: 850

    visible: root.opened || flyout.opacity > 0

    anchors {
        left: true
        right: true
        bottom: true
    }

    margins.bottom: root.theme.lockFlyoutBottomMargin
    implicitHeight: root.theme.lockFlyoutPanelHeight
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    focusable: false
    mask: Region {}

    function showState(enabled: bool): void {
        root.lockEnabled = enabled;
        root.opened = true;
        hideTimer.restart();
    }

    Timer {
        id: hideTimer

        interval: root.displayDuration

        onTriggered: root.opened = false
    }

    Rectangle {
        id: flyout

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        width: root.theme.lockFlyoutSize
        height: root.theme.lockFlyoutSize
        radius: root.theme.lockFlyoutRadius
        color: root.theme.lockFlyoutBg
        opacity: root.opened ? root.theme.lockFlyoutOpacity : 0

        transform: Translate {
            y: root.opened ? 0 : root.theme.lockFlyoutHiddenOffset

            Behavior on y {
                NumberAnimation {
                    duration: root.theme.animationDuration
                    easing.type: Easing.OutCubic
                }
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: root.theme.animationDuration
                easing.type: Easing.OutCubic
            }
        }

        Image {
            anchors.centerIn: parent

            width: root.theme.lockFlyoutIconSize
            height: width
            source: Quickshell.shellDir + "/assets/" + (root.lockEnabled ? root.enabledIcon : root.disabledIcon)
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
        }
    }
}
