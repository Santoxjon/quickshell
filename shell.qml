import QtQuick
import Quickshell
import Quickshell.Services.Notifications

import "."
import "./panels"
import "./popups"
import "./drawers"

ShellRoot {
    id: root

    property bool audioHover: false
    property bool drawerHover: false

    Theme {
        id: appTheme
    }

    TopBar {
        id: topBar
        theme: appTheme

        activeBorder: audioDrawer.fullyOpened

        onAudioHovered: {
            audioHover = true;
            closeAudioTimer.stop();
            updateAudioDrawer();
        }

        onAudioUnhovered: {
            audioHover = false;
            closeAudioTimer.restart();
        }
    }

    property string activeDrawer: ""

    AudioDrawer {
        id: audioDrawer
        theme: appTheme
        anchorWindow: topBar
        opened: root.activeDrawer === "audio"

        onEntered: {
            drawerHover = true;
            closeAudioTimer.stop();
            updateAudioDrawer();
        }

        onExited: {
            drawerHover = false;
            closeAudioTimer.restart();
        }
    }

    Timer {
        id: closeAudioTimer
        interval: 1
        repeat: false

        onTriggered: updateAudioDrawer()
    }

    NotificationServer {
        id: notificationServer
        bodySupported: true
        actionsSupported: true
        imageSupported: true
        bodyImagesSupported: true
        actionIconsSupported: true

        onNotification: function (n) {
            console.log("NOTIFICATION:", n.appName, n.appIcon, n.image, n.desktopEntry, n.summary, n.body);

            n.tracked = true;
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

    function updateAudioDrawer() {
        audioDrawer.opened = audioHover || drawerHover;
    }
}
