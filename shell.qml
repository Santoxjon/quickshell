pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

import qs.drawers
import qs.panels
import qs.popups

ShellRoot {
    id: root

    property bool audioModuleHovered: false
    property bool audioDrawerHovered: false

    function updateAudioDrawer(): void {
        audioDrawer.opened = root.audioModuleHovered || root.audioDrawerHovered;
    }

    Theme {
        id: appTheme
    }

    TopBar {
        id: topBar
        theme: appTheme

        activeBorder: audioDrawer.fullyOpened

        onAudioHovered: {
            root.audioModuleHovered = true;
            audioDrawerCloseTimer.stop();
            root.updateAudioDrawer();
        }

        onAudioUnhovered: {
            root.audioModuleHovered = false;
            audioDrawerCloseTimer.restart();
        }
    }

    AudioDrawer {
        id: audioDrawer
        theme: appTheme
        anchorWindow: topBar

        onEntered: {
            root.audioDrawerHovered = true;
            audioDrawerCloseTimer.stop();
            root.updateAudioDrawer();
        }

        onExited: {
            root.audioDrawerHovered = false;
            audioDrawerCloseTimer.restart();
        }
    }

    Timer {
        id: audioDrawerCloseTimer
        interval: 1
        repeat: false

        onTriggered: root.updateAudioDrawer()
    }

    NotificationServer {
        id: notificationServer
        bodySupported: true
        actionsSupported: true
        imageSupported: true
        bodyImagesSupported: true
        actionIconsSupported: true

        onNotification: function (notification) {
            notification.tracked = true;
        }
    }

    Repeater {
        model: notificationServer.trackedNotifications

        delegate: Item {
            id: delegateRoot

            required property var modelData
            required property int index

            NotificationPopup {
                notification: delegateRoot.modelData
                anchorWindow: topBar
                theme: appTheme
                popupIndex: delegateRoot.index
            }
        }
    }

    VolumeFlyout {
        theme: appTheme
    }

    NumLockFlyout {
        theme: appTheme
    }

    CapsLockFlyout {
        theme: appTheme
    }
}
