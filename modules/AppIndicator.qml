pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

import qs.components
import qs.services

Row {
    id: root

    required property var theme
    property var activeApplications: []
    property int hiddenWorkspaceId: 99
    property int modeSwitchGracePeriod: 5000
    property int modeSwitchMaximumHold: 15000
    property string amulePendingMode: ""
    property bool amuleClosePending: false
    property var applications: [
        {
            "id": "discord",
            "name": "Discord",
            "extraActions": []
        },
        {
            "id": "steam",
            "name": "Steam",
            "extraActions": []
        },
        {
            "id": "amule",
            "name": "aMule",
            "serviceUnit": "amuled.service",
            "modeSwitchCommand": [Quickshell.shellDir + "/scripts/amule-mode.sh"],
            "extraActions": []
        }
    ]

    readonly property var amuleServiceState: amuleService.active ? {
        "id": "amule",
        "mode": "service",
        "workspaceId": -1,
        "windows": []
    } : null
    readonly property var amuleTransitionState: root.amulePendingMode.length > 0 ? {
        "id": "amule",
        "mode": "transition",
        "targetMode": root.amulePendingMode,
        "workspaceId": -1,
        "windows": []
    } : null

    anchors.verticalCenter: parent.verticalCenter
    height: root.theme.appIndicatorIconSize
    spacing: root.theme.appIndicatorSpacing

    function applicationState(applicationId: string): var {
        if (applicationId === "amule" && root.amuleClosePending)
            return null;

        if (applicationId === "amule" && root.amuleTransitionState)
            return root.amuleTransitionState;

        for (const application of root.activeApplications) {
            if (application.id === applicationId)
                return application;
        }

        if (applicationId === "amule")
            return root.amuleServiceState;

        return null;
    }

    function amuleGuiIsActive(): bool {
        for (const application of root.activeApplications) {
            if (application.id === "amule")
                return true;
        }

        return false;
    }

    function beginAmuleModeTransition(targetMode: string): void {
        root.amulePendingMode = targetMode;
        modeSwitchGraceTimer.interval = root.modeSwitchMaximumHold;
        modeSwitchGraceTimer.restart();
    }

    function finishAmuleModeTransition(targetMode: string, succeeded: bool): void {
        if (root.amulePendingMode !== targetMode)
            return;

        if (!succeeded) {
            root.amulePendingMode = "";
            modeSwitchGraceTimer.stop();
            return;
        }

        root.updateAmuleModeTransition();

        if (root.amulePendingMode.length > 0) {
            modeSwitchGraceTimer.interval = root.modeSwitchGracePeriod;
            modeSwitchGraceTimer.restart();
        }
    }

    function updateAmuleModeTransition(): void {
        if (root.amulePendingMode === "gui" && root.amuleGuiIsActive()) {
            root.amulePendingMode = "";
            modeSwitchGraceTimer.stop();
        } else if (root.amulePendingMode === "service" && amuleService.active) {
            root.amulePendingMode = "";
            modeSwitchGraceTimer.stop();
        }
    }

    function beginAmuleServiceClose(): void {
        root.amuleClosePending = true;
    }

    function finishAmuleServiceClose(succeeded: bool): void {
        if (!succeeded || !amuleService.active)
            root.amuleClosePending = false;
    }

    Repeater {
        model: root.applications

        delegate: Item {
            id: applicationIcon

            required property var modelData

            readonly property var applicationState: root.applicationState(applicationIcon.modelData.id)

            anchors.verticalCenter: parent.verticalCenter
            visible: applicationIcon.applicationState !== null
            width: root.theme.appIndicatorIconSize
            height: width

            Image {
                anchors.fill: parent
                sourceSize: Qt.size(width, height)
                fillMode: Image.PreserveAspectFit
                source: Quickshell.shellDir + "/assets/" + applicationIcon.modelData.id + ".png"
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: Qt.PointingHandCursor

                onClicked: function (mouse) {
                    if (mouse.button === Qt.RightButton)
                        contextMenu.openMenu();
                }

                onDoubleClicked: function (mouse) {
                    if (mouse.button === Qt.LeftButton)
                        contextMenu.focusWorkspace();
                }
            }

            AppIndicatorContextMenu {
                id: contextMenu

                theme: root.theme
                anchorItem: applicationIcon
                application: applicationIcon.applicationState
                hiddenWorkspaceId: root.hiddenWorkspaceId
                extraActions: applicationIcon.modelData.extraActions ?? []
                serviceUnit: applicationIcon.modelData.serviceUnit ?? ""
                modeSwitchCommand: applicationIcon.modelData.modeSwitchCommand ?? []

                onModeSwitchStarted: targetMode => root.beginAmuleModeTransition(targetMode)
                onModeSwitchFinished: (targetMode, succeeded) => root.finishAmuleModeTransition(targetMode, succeeded)
                onServiceCloseStarted: root.beginAmuleServiceClose()
                onServiceCloseFinished: succeeded => root.finishAmuleServiceClose(succeeded)
            }
        }
    }

    JsonLineProcess {
        running: true
        logName: "Application indicator"
        command: [Quickshell.shellDir + "/scripts/app-indicator.sh"]

        onJsonReceived: value => {
            if (!Array.isArray(value)) {
                root.activeApplications = [];
                return;
            }

            root.activeApplications = value.map(application => {
                application.mode = "gui";
                return application;
            });

            root.updateAmuleModeTransition();
        }
    }

    SystemdUnitStatus {
        id: amuleService

        unitName: "amuled.service"

        onActiveChanged: {
            if (!active)
                root.amuleClosePending = false;

            root.updateAmuleModeTransition();
        }
    }

    Timer {
        id: modeSwitchGraceTimer

        interval: root.modeSwitchGracePeriod
        repeat: false

        onTriggered: root.amulePendingMode = ""
    }
}
