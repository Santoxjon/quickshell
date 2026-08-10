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
    readonly property string amuleApplicationId: "amule"
    readonly property string amuleServiceUnit: "amuled.service"
    readonly property var applicationDefinitions: [
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
            "id": "telegram",
            "name": "Telegram",
            "extraActions": []
        },
        {
            "id": "firefox",
            "name": "Firefox",
            "showWindowCount": true,
            "individualWindowMovement": true,
            "extraActions": [
                {
                    "id": "new-window",
                    "text": "Open new window",
                    "dispatcher": "hl.dsp.exec_cmd(\"firefox --new-window\")"
                },
                {
                    "id": "new-private-window",
                    "text": "Open new private window",
                    "dispatcher": "hl.dsp.exec_cmd(\"firefox --private-window\")"
                }
            ]
        },
        {
            "id": "code",
            "name": "Code",
            "extraActions": []
        },
        {
            "id": root.amuleApplicationId,
            "name": "aMule",
            "serviceUnit": root.amuleServiceUnit,
            "modeSwitchCommand": [Quickshell.shellDir + "/scripts/amule-mode.sh"],
            "statusCommand": ["amulecmd", "-c", "status"],
            "extraActions": []
        }
    ]

    anchors.verticalCenter: parent.verticalCenter
    height: root.theme.appIndicatorIconSize
    spacing: root.theme.appIndicatorSpacing

    function applicationState(applicationId: string): var {
        if (applicationId === root.amuleApplicationId)
            return amuleService.applicationState();

        for (const application of root.activeApplications) {
            if (application.id === applicationId)
                return application;
        }

        return null;
    }

    Repeater {
        model: root.applicationDefinitions

        delegate: Item {
            id: applicationIcon

            required property var modelData

            readonly property var applicationState: root.applicationState(applicationIcon.modelData.id)
            readonly property int windowCount: applicationIcon.applicationState && Array.isArray(applicationIcon.applicationState.windows)
                ? applicationIcon.applicationState.windows.length
                : 0

            anchors.verticalCenter: parent.verticalCenter
            visible: applicationIcon.applicationState !== null
            width: root.theme.appIndicatorIconSize
            height: width

            Image {
                anchors.fill: parent
                sourceSize: Qt.size(width, height)
                fillMode: Image.PreserveAspectFit
                source: applicationIcon.modelData.iconName
                    ? Quickshell.iconPath(applicationIcon.modelData.iconName)
                    : Quickshell.shellDir + "/assets/" + applicationIcon.modelData.id + ".png"
            }

            Rectangle {
                id: windowCountBadge

                visible: applicationIcon.modelData.showWindowCount === true && applicationIcon.windowCount > 1
                z: 2

                width: Math.max(root.theme.appIndicatorCountBadgeSize, countLabel.implicitWidth + 4)
                height: root.theme.appIndicatorCountBadgeSize
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.rightMargin: -root.theme.appIndicatorCountBadgeOffset
                anchors.bottomMargin: -root.theme.appIndicatorCountBadgeOffset
                radius: height / 2
                color: root.theme.palette1
                border.width: root.theme.thinBorderWidth
                border.color: root.theme.bg

                ModuleText {
                    id: countLabel

                    anchors.centerIn: parent
                    theme: root.theme
                    text: applicationIcon.windowCount.toString()
                    color: root.theme.palette7
                    font.pixelSize: root.theme.appIndicatorCountBadgeFontSize
                }
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onEntered: indicatorTooltip.beginHover()
                onExited: indicatorTooltip.endHover()

                onClicked: function (mouse) {
                    if (mouse.button === Qt.RightButton) {
                        indicatorTooltip.dismiss();
                        contextMenu.openMenu();
                    }
                }

                onDoubleClicked: function (mouse) {
                    if (mouse.button !== Qt.LeftButton)
                        return;

                    if (applicationIcon.modelData.id === root.amuleApplicationId
                            && applicationIcon.applicationState?.mode === "service") {
                        amuleService.showStatus();
                    } else {
                        contextMenu.focusWorkspace();
                    }
                }
            }

            AppIndicatorTooltip {
                id: indicatorTooltip

                theme: root.theme
                anchorItem: applicationIcon
                label: applicationIcon.modelData.name
            }

            AppIndicatorContextMenu {
                id: contextMenu

                theme: root.theme
                anchorItem: applicationIcon
                application: applicationIcon.applicationState
                applicationName: applicationIcon.modelData.name
                hiddenWorkspaceId: root.hiddenWorkspaceId
                extraActions: applicationIcon.modelData.extraActions ?? []
                serviceUnit: applicationIcon.modelData.serviceUnit ?? ""
                modeSwitchCommand: applicationIcon.modelData.modeSwitchCommand ?? []
                statusCommand: applicationIcon.modelData.statusCommand ?? []
                individualWindowMovement: applicationIcon.modelData.individualWindowMovement === true

                onModeSwitchStarted: targetMode => amuleService.beginModeTransition(targetMode)
                onModeSwitchFinished: (targetMode, succeeded) => amuleService.finishModeTransition(targetMode, succeeded)
                onServiceCloseStarted: amuleService.beginServiceClose()
                onServiceCloseFinished: succeeded => amuleService.finishServiceClose(succeeded)
            }
        }
    }

    AmuleService {
        id: amuleService

        activeApplications: root.activeApplications
        applicationId: root.amuleApplicationId
        serviceUnit: root.amuleServiceUnit
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

            root.activeApplications = value.map(application =>
                Object.assign({}, application, { "mode": "gui" }));
        }
    }
}
