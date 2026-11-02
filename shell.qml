pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

import qs.drawers
import qs.panels
import qs.popups
import qs.services

ShellRoot {
    id: root

    property bool audioModuleHovered: false
    property bool audioDrawerHovered: false
    property bool cpuModuleHovered: false
    property bool cpuDrawerHovered: false
    property bool networkModuleHovered: false
    property bool networkDrawerHovered: false

    function updateAudioDrawer(): void {
        audioDrawer.opened = root.audioModuleHovered || root.audioDrawerHovered;
    }

    function updateCpuDrawer(): void {
        cpuDrawer.opened = root.cpuModuleHovered || root.cpuDrawerHovered;
    }

    function updateNetworkDrawer(): void {
        networkDrawer.opened = root.networkModuleHovered || root.networkDrawerHovered;
    }

    Theme {
        id: appTheme
    }

    CpuUsage {
        id: cpuUsage
    }

    TopBar {
        id: topBar
        theme: appTheme
        cpuUsage: cpuUsage

        activeBorder: audioDrawer.fullyOpened || cpuDrawer.fullyOpened || networkDrawer.fullyOpened

        onAudioHovered: {
            root.audioModuleHovered = true;
            audioDrawerCloseTimer.stop();
            root.updateAudioDrawer();
        }

        onAudioUnhovered: {
            root.audioModuleHovered = false;
            audioDrawerCloseTimer.restart();
        }

        onCpuHovered: {
            root.cpuModuleHovered = true;
            cpuDrawerCloseTimer.stop();
            root.updateCpuDrawer();
        }

        onCpuUnhovered: {
            root.cpuModuleHovered = false;
            cpuDrawerCloseTimer.restart();
        }

        onNetworkHovered: {
            root.networkModuleHovered = true;
            networkDrawerCloseTimer.stop();
            root.updateNetworkDrawer();
        }

        onNetworkUnhovered: {
            root.networkModuleHovered = false;
            networkDrawerCloseTimer.restart();
        }

        onShutdownRequested: powerMenu.openMenu()
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

    CpuDrawer {
        id: cpuDrawer
        theme: appTheme
        anchorItem: topBar.cpuAnchorItem
        cpuUsage: cpuUsage

        onEntered: {
            root.cpuDrawerHovered = true;
            cpuDrawerCloseTimer.stop();
            root.updateCpuDrawer();
        }

        onExited: {
            root.cpuDrawerHovered = false;
            cpuDrawerCloseTimer.restart();
        }
    }

    Timer {
        id: cpuDrawerCloseTimer
        interval: 1
        repeat: false

        onTriggered: root.updateCpuDrawer()
    }

    NetworkDrawer {
        id: networkDrawer
        theme: appTheme
        anchorItem: topBar.networkAnchorItem
        networkModule: topBar.networkModule

        onEntered: {
            root.networkDrawerHovered = true;
            networkDrawerCloseTimer.stop();
            root.updateNetworkDrawer();
        }

        onExited: {
            root.networkDrawerHovered = false;
            networkDrawerCloseTimer.restart();
        }
    }

    Timer {
        id: networkDrawerCloseTimer
        interval: 1
        repeat: false
        onTriggered: root.updateNetworkDrawer()
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

    AppLauncher {
        theme: appTheme
    }

    PowerMenu {
        id: powerMenu

        theme: appTheme
    }
}
