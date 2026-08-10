pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

import "AppIndicatorMenuUtils.js" as MenuUtils

PopupWindow {
    id: root

    required property var theme
    required property Item anchorItem
    required property var application
    property string applicationName: "Application"
    required property int hiddenWorkspaceId
    property var extraActions: []
    property string serviceUnit: ""
    property var modeSwitchCommand: []
    property var statusCommand: []
    property int statusRefreshInterval: root.theme.appIndicatorStatusRefreshInterval
    property bool individualWindowMovement: false
    property var pendingMoveWindows: []
    property int pendingWorkspaceId: -1
    property string windowPickerAction: ""
    property bool statusPageOpened: false
    property bool menuOpened: false
    property string statusServer: "Disconnected"
    property string statusKad: "Disconnected"
    property string statusDownload: "--"
    property string statusUpload: "--"

    readonly property int moveAnimationDuration: 200
    readonly property real moveAnimationSpeed: root.moveAnimationDuration / 100
    readonly property real defaultAnimationSpeed: 8
    readonly property bool serviceManaged: root.serviceUnit.length > 0 && root.modeSwitchCommand.length > 0
    readonly property bool statusManaged: root.statusCommand.length > 0
    readonly property bool serviceMode: root.serviceManaged && root.application && root.application.mode === "service"
    readonly property bool transitionMode: root.serviceManaged && root.application && root.application.mode === "transition"
    readonly property bool windowPickerOpened: root.windowPickerAction.length > 0
    readonly property bool submenuOpened: root.windowPickerOpened || root.statusPageOpened
    readonly property bool applicationHidden: MenuUtils.applicationIsHidden(root.application, root.hiddenWorkspaceId)
    readonly property var nonHiddenWindowModel: MenuUtils.nonHiddenWindows(root.application, root.hiddenWorkspaceId)
    readonly property var hiddenWindowModel: MenuUtils.hiddenWindows(root.application, root.hiddenWorkspaceId)
    readonly property int applicationWorkspaceId: MenuUtils.focusWorkspaceId(
        root.application,
        root.individualWindowMovement,
        root.hiddenWorkspaceId
    )
    readonly property var windowPickerModel: MenuUtils.windowPickerCandidates(
        root.windowPickerAction,
        root.application,
        root.hiddenWorkspaceId
    )

    property string activeModeSwitchTarget: ""

    signal modeSwitchStarted(string targetMode)
    signal modeSwitchFinished(string targetMode, bool succeeded)
    signal serviceCloseStarted
    signal serviceCloseFinished(bool succeeded)

    visible: root.anchorItem.visible && root.menuOpened
    grabFocus: false
    color: "transparent"
    mask: Region {
        width: root.menuOpened ? root.width : 0
        height: root.menuOpened ? root.height : 0
    }

    implicitWidth: root.submenuOpened ? root.theme.appIndicatorWindowPickerWidth : root.theme.appIndicatorMenuWidth
    implicitHeight: menuColumn.implicitHeight + 2 * root.theme.appIndicatorMenuPadding

    anchor.item: root.anchorItem
    anchor.rect.x: (root.anchorItem.width - root.implicitWidth) / 2
    anchor.rect.y: (root.theme.barHeight + root.anchorItem.height) / 2
    anchor.adjustment: PopupAdjustment.SlideX

    function openMenu(): void {
        if (!root.application)
            return;

        root.windowPickerAction = "";
        root.statusPageOpened = false;
        root.menuOpened = true;
        menuFocusGrab.active = true;

        if (root.statusManaged)
            root.refreshStatus();
    }

    function closeMenu(): void {
        root.windowPickerAction = "";
        root.statusPageOpened = false;
        root.menuOpened = false;
        menuFocusGrab.active = false;

        if (statusProcess.running)
            statusProcess.signal(15);
    }

    onVisibleChanged: {
        if (!root.visible) {
            root.menuOpened = false;
            root.windowPickerAction = "";
            root.statusPageOpened = false;

            if (statusProcess.running)
                statusProcess.signal(15);
        }
    }

    HyprlandFocusGrab {
        id: menuFocusGrab

        windows: [root]

        onCleared: {
            if (root.menuOpened)
                root.closeMenu();
        }
    }

    function focusWorkspace(): void {
        if (!root.application || root.serviceMode || root.transitionMode || root.applicationHidden)
            return;

        const workspaceId = root.applicationWorkspaceId;

        if (!Number.isInteger(workspaceId) || workspaceId <= 0) {
            console.warn(`Application indicator: invalid workspace for ${root.application.id}`);
            root.closeMenu();
            return;
        }

        Hyprland.dispatch(`hl.dsp.focus({ workspace = ${workspaceId} })`);
        root.closeMenu();
    }

    function openWindowPicker(action: string): void {
        root.statusPageOpened = false;
        root.windowPickerAction = action;
        Qt.callLater(() => root.anchor.updateAnchor());
    }

    function openStatusPage(): void {
        root.windowPickerAction = "";
        root.statusPageOpened = true;
        Qt.callLater(() => root.anchor.updateAnchor());
    }

    function closeSubmenu(): void {
        root.windowPickerAction = "";
        root.statusPageOpened = false;
        Qt.callLater(() => root.anchor.updateAnchor());
    }

    function refreshStatus(): void {
        if (!root.menuOpened || !root.statusManaged || statusProcess.running)
            return;

        statusProcess.running = true;
    }

    function parseStatus(output: string): void {
        const status = MenuUtils.parseAmuleStatus(output);
        root.statusServer = status.server;
        root.statusKad = status.kad;
        root.statusDownload = status.download;
        root.statusUpload = status.upload;
    }

    function moveApplicationToWorkspace(workspaceId: int): void {
        if (!root.application || !Number.isInteger(workspaceId) || workspaceId <= 0)
            return;

        root.moveWindowsToWorkspace(MenuUtils.applicationWindows(root.application), workspaceId);
    }

    function moveWindowsToWorkspace(windows, workspaceId: int): void {
        if (!Array.isArray(windows) || !Number.isInteger(workspaceId) || workspaceId <= 0)
            return;

        const validAddresses = MenuUtils.validWindowAddresses(windows);
        const validWindows = validAddresses.map(address => ({"address": address}));

        if (validAddresses.length !== windows.length)
            console.warn(`Application indicator: invalid window address for ${root.application.id}`);

        if (validWindows.length === 0)
            return;

        root.pendingMoveWindows = validWindows;
        root.pendingWorkspaceId = workspaceId;
        root.closeMenu();
        animationSetupProcess.running = true;
    }

    function performPendingMove(): void {
        const workspaceId = root.pendingWorkspaceId;
        const windows = root.pendingMoveWindows;

        root.pendingWorkspaceId = -1;
        root.pendingMoveWindows = [];

        if (!Number.isInteger(workspaceId) || workspaceId <= 0)
            return;

        for (const appWindow of windows)
            Hyprland.dispatch(`hl.dsp.window.move({ workspace = ${workspaceId}, follow = false, window = "address:${appWindow.address}" })`);
    }

    function sendToHiddenWorkspace(): void {
        if (root.serviceMode)
            return;

        if (root.individualWindowMovement) {
            root.openWindowPicker("send");
            return;
        }

        root.moveApplicationToWorkspace(root.hiddenWorkspaceId);
    }

    function bringHere(): void {
        if (!Hyprland.focusedWorkspace) {
            console.warn("Application indicator: cannot bring application without a focused workspace");
            return;
        }

        if (root.individualWindowMovement) {
            root.openWindowPicker("bring");
            return;
        }

        root.moveApplicationToWorkspace(Hyprland.focusedWorkspace.id);
    }

    function movePickedWindow(appWindow): void {
        if (!appWindow)
            return;

        const workspaceId = root.windowPickerAction === "send"
            ? root.hiddenWorkspaceId
            : (Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : -1);

        root.moveWindowsToWorkspace([appWindow], workspaceId);
    }

    function closeApplication(): void {
        if (root.serviceMode) {
            serviceControlProcess.command = ["systemctl", "stop", root.serviceUnit];
            root.serviceCloseStarted();
            serviceControlProcess.running = true;
            root.closeMenu();
            return;
        }

        if (!root.application)
            return;

        const windows = MenuUtils.applicationWindows(root.application);
        const validAddresses = MenuUtils.validWindowAddresses(windows);

        if (validAddresses.length !== windows.length)
            console.warn(`Application indicator: invalid window address for ${root.application.id}`);

        for (const address of validAddresses)
            Hyprland.dispatch(`hl.dsp.window.close({ window = "address:${address}" })`);

        root.closeMenu();
    }

    function switchApplicationMode(): void {
        if (!root.serviceManaged || root.transitionMode || modeSwitchProcess.running)
            return;

        root.activeModeSwitchTarget = root.serviceMode ? "gui" : "service";
        modeSwitchProcess.command = root.modeSwitchCommand.concat([root.activeModeSwitchTarget]);
        root.modeSwitchStarted(root.activeModeSwitchTarget);
        modeSwitchProcess.running = true;
        root.closeMenu();
    }

    function runExtraAction(action): void {
        if (!action)
            return;

        if (typeof action.trigger === "function") {
            action.trigger(root.application);
        } else if (typeof action.dispatcher === "string" && action.dispatcher.length > 0) {
            Hyprland.dispatch(action.dispatcher);
        } else {
            console.warn(`Application indicator: action ${action.id ?? action.text ?? "unknown"} has no trigger or dispatcher`);
        }

        root.closeMenu();
    }

    Process {
        id: statusProcess

        command: root.statusCommand

        stdout: StdioCollector {
            id: statusStdout
        }

        stderr: StdioCollector {}

        onExited: function () {
            root.parseStatus(statusStdout.text);
        }
    }

    Timer {
        interval: root.statusRefreshInterval
        running: root.menuOpened && root.statusManaged
        repeat: true

        onTriggered: root.refreshStatus()
    }

    Process {
        id: modeSwitchProcess

        stdout: SplitParser {
            onRead: line => console.log(`Application mode switch: ${line}`)
        }

        stderr: SplitParser {
            onRead: line => console.warn(`Application mode switch: ${line}`)
        }

        onExited: function (exitCode) {
            if (exitCode !== 0)
                console.warn(`Application indicator: mode switch failed with exit code ${exitCode}`);

            root.modeSwitchFinished(root.activeModeSwitchTarget, exitCode === 0);
            root.activeModeSwitchTarget = "";
        }
    }

    Process {
        id: serviceControlProcess

        stdout: StdioCollector {}

        stderr: SplitParser {
            onRead: line => console.warn(`Application service control: ${line}`)
        }

        onExited: function (exitCode) {
            if (exitCode !== 0)
                console.warn(`Application indicator: service control failed with exit code ${exitCode}`);

            root.serviceCloseFinished(exitCode === 0);
        }
    }

    Process {
        id: animationSetupProcess

        command: ["hyprctl", "eval", MenuUtils.animationConfiguration(root.moveAnimationSpeed)]

        stdout: StdioCollector {}

        stderr: SplitParser {
            onRead: line => console.warn(`Application indicator animation: ${line}`)
        }

        onExited: function (exitCode) {
            if (exitCode !== 0)
                console.warn("Application indicator: could not enable the Send/Bring animation");

            root.performPendingMove();

            if (exitCode === 0)
                animationRestoreTimer.restart();
        }
    }

    Timer {
        id: animationRestoreTimer

        interval: root.moveAnimationDuration + 30
        repeat: false

        onTriggered: animationRestoreProcess.running = true
    }

    Process {
        id: animationRestoreProcess

        command: ["hyprctl", "eval", MenuUtils.animationConfiguration(root.defaultAnimationSpeed)]

        stdout: StdioCollector {}

        stderr: SplitParser {
            onRead: line => console.warn(`Application indicator animation restore: ${line}`)
        }

        onExited: function (exitCode) {
            if (exitCode !== 0)
                console.warn("Application indicator: could not restore the default Hyprland animation speed");
        }
    }

    Rectangle {
        anchors.fill: parent

        radius: root.theme.cornerRadius
        color: root.theme.bg
        border.width: root.theme.borderWidth
        border.color: root.theme.border

        Column {
            id: menuColumn

            anchors.centerIn: parent
            spacing: root.theme.appIndicatorMenuItemSpacing

            ContextMenuAction {
                visible: root.submenuOpened
                theme: root.theme
                availableWidth: root.implicitWidth
                label: "← Back"

                onTriggered: root.closeSubmenu()
            }

            ContextMenuAction {
                visible: root.windowPickerOpened
                theme: root.theme
                availableWidth: root.implicitWidth
                label: root.windowPickerAction === "send"
                    ? "Select a window to hide"
                    : "Select a window to bring here"
                actionEnabled: false
            }

            Repeater {
                model: root.windowPickerModel

                delegate: ContextMenuAction {
                    id: windowPickerItem

                    required property var modelData
                    required property int index

                    theme: root.theme
                    availableWidth: root.implicitWidth
                    label: MenuUtils.windowPickerLabel(
                        windowPickerItem.modelData,
                        windowPickerItem.index,
                        root.applicationName
                    )
                    actionEnabled: root.windowPickerAction === "send" || Hyprland.focusedWorkspace !== null

                    onTriggered: root.movePickedWindow(windowPickerItem.modelData)
                }
            }

            ContextMenuAction {
                visible: root.statusPageOpened
                theme: root.theme
                availableWidth: root.implicitWidth
                label: "aMule status"
                actionEnabled: false
            }

            ContextMenuAction {
                visible: root.statusPageOpened
                theme: root.theme
                availableWidth: root.implicitWidth
                label: `  ${root.statusServer}`
                actionEnabled: false
                dimWhenDisabled: false
            }

            ContextMenuAction {
                visible: root.statusPageOpened
                theme: root.theme
                availableWidth: root.implicitWidth
                label: `  ${root.statusKad}`
                actionEnabled: false
                dimWhenDisabled: false
            }

            ContextMenuAction {
                visible: root.statusPageOpened
                theme: root.theme
                availableWidth: root.implicitWidth
                label: `  ${root.statusDownload}`
                actionEnabled: false
                dimWhenDisabled: false
            }

            ContextMenuAction {
                visible: root.statusPageOpened
                theme: root.theme
                availableWidth: root.implicitWidth
                label: `  ${root.statusUpload}`
                actionEnabled: false
                dimWhenDisabled: false
            }

            ContextMenuAction {
                visible: !root.submenuOpened && root.serviceManaged
                theme: root.theme
                label: root.transitionMode
                    ? (root.application.targetMode === "service" ? "Switching to Service..." : "Switching to GUI...")
                    : (root.serviceMode ? "Running mode: Service" : "Running mode: GUI")
                actionEnabled: false
            }

            ContextMenuAction {
                visible: !root.submenuOpened && root.statusManaged
                theme: root.theme
                label: "Check status →"

                onTriggered: root.openStatusPage()
            }

            ContextMenuAction {
                visible: !root.submenuOpened
                theme: root.theme
                label: "Focus workspace"
                actionEnabled: root.applicationWorkspaceId > 0 && !root.transitionMode

                onTriggered: root.focusWorkspace()
            }

            Repeater {
                model: root.extraActions ?? []

                delegate: ContextMenuAction {
                    id: extraActionItem

                    required property var modelData

                    visible: !root.submenuOpened
                    theme: root.theme
                    label: String(extraActionItem.modelData.text ?? extraActionItem.modelData.id ?? "Action")
                    actionEnabled: extraActionItem.modelData.enabled !== false

                    onTriggered: root.runExtraAction(extraActionItem.modelData)
                }
            }

            ContextMenuAction {
                visible: !root.submenuOpened
                    && (root.individualWindowMovement ? root.nonHiddenWindowModel.length > 0 : !root.applicationHidden)
                theme: root.theme
                label: "Send to hidden workspace"
                actionEnabled: !root.serviceMode && !root.transitionMode

                onTriggered: root.sendToHiddenWorkspace()
            }

            ContextMenuAction {
                visible: !root.submenuOpened
                    && (root.individualWindowMovement ? root.hiddenWindowModel.length > 0 : root.applicationHidden)
                theme: root.theme
                label: "Bring here"
                actionEnabled: Hyprland.focusedWorkspace !== null

                onTriggered: root.bringHere()
            }

            ContextMenuAction {
                visible: !root.submenuOpened && root.serviceManaged
                theme: root.theme
                label: root.serviceMode ? "Switch to GUI mode" : "Switch to service mode"
                actionEnabled: !root.transitionMode && !modeSwitchProcess.running && !serviceControlProcess.running

                onTriggered: root.switchApplicationMode()
            }

            Rectangle {
                visible: !root.submenuOpened
                width: root.implicitWidth - 2 * root.theme.appIndicatorMenuPadding
                height: root.theme.thinBorderWidth
                color: root.theme.separator
            }

            ContextMenuAction {
                visible: !root.submenuOpened
                theme: root.theme
                label: "Close application"
                actionEnabled: !root.transitionMode

                onTriggered: root.closeApplication()
            }
        }
    }
}
