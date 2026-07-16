pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Hyprland

import qs.components

Row {
    id: root

    required property var theme
    readonly property int alwaysVisibleWorkspaceCount: 4
    readonly property var workspaceLabels: ["", "1: kitty", "2: firefox", "3: spotify", "4: code", "5: discord", "6: steam"]

    function labelFor(workspaceId: int): string {
        const label = root.workspaceLabels[workspaceId];

        return label ?? workspaceId.toString();
    }

    function workspaceExists(workspaceId: int): bool {
        for (let i = 0; i < Hyprland.workspaces.values.length; i++) {
            if (Hyprland.workspaces.values[i].id === workspaceId)
                return true;
        }

        return false;
    }

    function shouldShow(workspaceId: int): bool {
        return workspaceId <= root.alwaysVisibleWorkspaceCount || root.workspaceExists(workspaceId);
    }

    Repeater {
        model: [1, 2, 3, 4, 5, 6, 7, 8, 9]

        delegate: Rectangle {
            id: item

            required property int modelData
            readonly property int workspaceId: modelData
            readonly property bool focused: Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === item.workspaceId

            visible: root.shouldShow(item.workspaceId)
            implicitWidth: label.implicitWidth
            implicitHeight: label.implicitHeight

            color: item.focused ? root.theme.activeBg : "transparent"

            ModuleText {
                id: label

                theme: root.theme
                text: root.labelFor(item.workspaceId)
                color: item.focused ? root.theme.activeFg : root.theme.fg

                leftPadding: root.theme.workspaceHorizontalPadding
                rightPadding: root.theme.workspaceHorizontalPadding
                topPadding: root.theme.workspaceVerticalPadding
                bottomPadding: root.theme.workspaceVerticalPadding
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${item.workspaceId} })`)
            }
        }
    }
}
