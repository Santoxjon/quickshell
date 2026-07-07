import QtQuick
import Quickshell.Hyprland

Row {
    id: root

    required property var theme

    spacing: 0

    function labelFor(id) {
        switch (id) {
        case 1:
            return "1: kitty";
        case 2:
            return "2: firefox";
        case 3:
            return "3: spotify";
        case 4:
            return "4: code";
        case 5:
            return "5: discord";
        case 6:
            return "6: steam";
        default:
            return id.toString();
        }
    }

    function getWorkspaceById(id) {
        for (let i = 0; i < Hyprland.workspaces.values.length; i++) {
            if (Hyprland.workspaces.values[i].id === id)
                return Hyprland.workspaces.values[i];
        }
        return null;
    }

    function workspaceExists(id) {
        for (let i = 0; i < Hyprland.workspaces.values.length; i++) {
            if (Hyprland.workspaces.values[i].id === id)
                return true;
        }

        return false;
    }

    function shouldShow(id) {
        return id <= 4 || workspaceExists(id);
    }

    Repeater {
        model: [1, 2, 3, 4, 5, 6, 7, 8, 9]

        delegate: Rectangle {
            id: item

            property int workspaceId: modelData
            property bool focused: Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === workspaceId

            visible: root.shouldShow(workspaceId)
            width: visible ? label.implicitWidth : 0
            height: label.implicitHeight
            radius: 0

            color: focused ? root.theme.activeBg : "transparent"

            Text {
                id: label

                text: root.labelFor(item.workspaceId)

                color: item.focused ? root.theme.activeFg : root.theme.fg

                font.family: root.theme.fontName
                font.pixelSize: 17
                font.weight: Font.ExtraBold

                horizontalAlignment: Text.AlignLeft
                leftPadding: 12
                rightPadding: 12
                topPadding: 4
                bottomPadding: 4
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${item.workspaceId} })`)
            }
        }
    }
}
