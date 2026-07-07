import QtQuick
import Quickshell
import Quickshell.Services.Notifications

import "."
import "./panels"
import "./popups"
import "./drawers"

ShellRoot {
    id: root

    Theme {
        id: appTheme
    }

    TopBar {
        id: topBar
        theme: appTheme

        onAudioHovered: {
            root.activeDrawer = "audio";
        }

        onAudioUnhovered: {
            // de momento puedes dejarlo vacío
            // para que no se cierre al mover el ratón hacia el drawer
        }
    }

    property string activeDrawer: ""

    AudioDrawer {
        theme: appTheme
        anchorWindow: topBar
        opened: root.activeDrawer === "audio"

        onExited: root.activeDrawer = ""
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
}
