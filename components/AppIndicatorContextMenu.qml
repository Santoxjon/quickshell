pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

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
    property bool individualWindowMovement: false
    property var pendingMoveWindows: []
    property int pendingWorkspaceId: -1
    property string windowPickerAction: ""
    property bool menuOpened: false

    readonly property int moveAnimationDuration: 200
    readonly property real moveAnimationSpeed: root.moveAnimationDuration / 100
    readonly property real defaultAnimationSpeed: 8
    readonly property bool serviceManaged: root.serviceUnit.length > 0 && root.modeSwitchCommand.length > 0
    readonly property bool serviceMode: root.serviceManaged && root.application && root.application.mode === "service"
    readonly property bool transitionMode: root.serviceManaged && root.application && root.application.mode === "transition"
    readonly property bool windowPickerOpened: root.windowPickerAction.length > 0
    readonly property var windowPickerModel: root.windowPickerCandidates()

    property string activeModeSwitchTarget: ""

    signal modeSwitchStarted(string targetMode)
    signal modeSwitchFinished(string targetMode, bool succeeded)
    signal serviceCloseStarted
    signal serviceCloseFinished(bool succeeded)

    visible: root.anchorItem.visible
    grabFocus: false
    color: "transparent"
    mask: Region {
        width: root.menuOpened ? root.width : 0
        height: root.menuOpened ? root.height : 0
    }

    implicitWidth: root.windowPickerOpened ? root.theme.appIndicatorWindowPickerWidth : root.theme.appIndicatorMenuWidth
    implicitHeight: menuColumn.implicitHeight + 2 * root.theme.appIndicatorMenuPadding

    anchor.item: root.anchorItem
    anchor.rect.x: (root.anchorItem.width - root.implicitWidth) / 2
    anchor.rect.y: (root.theme.barHeight + root.anchorItem.height) / 2
    anchor.adjustment: PopupAdjustment.SlideX

    function openMenu(): void {
        if (!root.application)
            return;

        root.windowPickerAction = "";
        root.menuOpened = true;
        menuFocusGrab.active = true;
    }

    function closeMenu(): void {
        root.windowPickerAction = "";
        root.menuOpened = false;
        menuFocusGrab.active = false;
    }

    onVisibleChanged: {
        if (!root.visible) {
            root.menuOpened = false;
            root.windowPickerAction = "";
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
        if (!root.application || root.serviceMode || root.transitionMode || root.applicationIsHidden())
            return;

        const workspaceId = root.focusWorkspaceId();

        if (!Number.isInteger(workspaceId) || workspaceId <= 0) {
            console.warn(`Application indicator: invalid workspace for ${root.application.id}`);
            root.closeMenu();
            return;
        }

        Hyprland.dispatch(`hl.dsp.focus({ workspace = ${workspaceId} })`);
        root.closeMenu();
    }

    function applicationIsHidden(): bool {
        if (!root.application || !Array.isArray(root.application.windows) || root.application.windows.length === 0)
            return false;

        return root.application.windows.every(appWindow => Number(appWindow.workspaceId) === root.hiddenWorkspaceId);
    }

    function windowIsHidden(appWindow): bool {
        return appWindow && Number(appWindow.workspaceId) === root.hiddenWorkspaceId;
    }

    function nonHiddenWindows(): var {
        if (!root.application || !Array.isArray(root.application.windows))
            return [];

        return root.application.windows.filter(appWindow => !root.windowIsHidden(appWindow));
    }

    function hiddenWindows(): var {
        if (!root.application || !Array.isArray(root.application.windows))
            return [];

        return root.application.windows.filter(appWindow => root.windowIsHidden(appWindow));
    }

    function focusWorkspaceId(): int {
        if (!root.application)
            return -1;

        if (root.individualWindowMovement) {
            const visibleWindows = root.nonHiddenWindows();
            return visibleWindows.length > 0 ? Number(visibleWindows[0].workspaceId) : -1;
        }

        return root.applicationIsHidden() ? -1 : Number(root.application.workspaceId);
    }

    function windowPickerCandidates(): var {
        if (root.windowPickerAction === "send")
            return root.nonHiddenWindows();

        if (root.windowPickerAction === "bring")
            return root.hiddenWindows();

        return [];
    }

    function openWindowPicker(action: string): void {
        root.windowPickerAction = action;
        Qt.callLater(() => root.anchor.updateAnchor());
    }

    function closeWindowPicker(): void {
        root.windowPickerAction = "";
        Qt.callLater(() => root.anchor.updateAnchor());
    }

    function windowPickerLabel(appWindow, index: int): string {
        const title = String(appWindow.title ?? "").trim();
        const displayTitle = title.length > 0 ? title : `${root.applicationName} window ${index + 1}`;
        return `${index + 1}. ${displayTitle}  ·  WS ${appWindow.workspaceId}`;
    }

    function moveApplicationToWorkspace(workspaceId: int): void {
        if (!root.application || !Array.isArray(root.application.windows) || !Number.isInteger(workspaceId) || workspaceId <= 0)
            return;

        root.moveWindowsToWorkspace(root.application.windows, workspaceId);
    }

    function moveWindowsToWorkspace(windows, workspaceId: int): void {
        if (!Array.isArray(windows) || !Number.isInteger(workspaceId) || workspaceId <= 0)
            return;

        const validWindows = [];

        for (const appWindow of windows) {
            const address = String(appWindow.address ?? "");

            if (!/^0x[0-9a-f]+$/i.test(address)) {
                console.warn(`Application indicator: invalid window address for ${root.application.id}`);
                continue;
            }

            validWindows.push({"address": address});
        }

        if (validWindows.length === 0)
            return;

        root.pendingMoveWindows = validWindows;
        root.pendingWorkspaceId = workspaceId;
        root.closeMenu();
        animationSetupProcess.running = true;
    }

    function animationConfiguration(speed: real): string {
        return [
            `hl.animation({ leaf = "windowsIn", enabled = true, speed = ${speed}, bezier = "default" })`,
            `hl.animation({ leaf = "windowsOut", enabled = true, speed = ${speed}, bezier = "default" })`,
            `hl.animation({ leaf = "windowsMove", enabled = true, speed = ${speed}, bezier = "default" })`,
            `hl.animation({ leaf = "fadeIn", enabled = true, speed = ${speed}, bezier = "default" })`,
            `hl.animation({ leaf = "fadeOut", enabled = true, speed = ${speed}, bezier = "default" })`
        ].join("; ");
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

        if (!root.application || !Array.isArray(root.application.windows))
            return;

        for (const appWindow of root.application.windows) {
            const address = String(appWindow.address ?? "");

            if (!/^0x[0-9a-f]+$/i.test(address)) {
                console.warn(`Application indicator: invalid window address for ${root.application.id}`);
                continue;
            }

            Hyprland.dispatch(`hl.dsp.window.close({ window = "address:${address}" })`);
        }

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

        command: ["hyprctl", "eval", root.animationConfiguration(root.moveAnimationSpeed)]

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

        command: ["hyprctl", "eval", root.animationConfiguration(root.defaultAnimationSpeed)]

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
        visible: root.menuOpened
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
                visible: root.windowPickerOpened
                theme: root.theme
                availableWidth: root.implicitWidth
                label: "← Back"

                onTriggered: root.closeWindowPicker()
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
                    label: root.windowPickerLabel(windowPickerItem.modelData, windowPickerItem.index)
                    actionEnabled: root.windowPickerAction === "send" || Hyprland.focusedWorkspace !== null

                    onTriggered: root.movePickedWindow(windowPickerItem.modelData)
                }
            }

            ContextMenuAction {
                visible: !root.windowPickerOpened && root.serviceManaged
                theme: root.theme
                label: root.transitionMode
                    ? (root.application.targetMode === "service" ? "Switching to Service..." : "Switching to GUI...")
                    : (root.serviceMode ? "Running mode: Service" : "Running mode: GUI")
                actionEnabled: false
            }

            ContextMenuAction {
                visible: !root.windowPickerOpened
                theme: root.theme
                label: "Focus workspace"
                actionEnabled: root.focusWorkspaceId() > 0 && !root.transitionMode

                onTriggered: root.focusWorkspace()
            }

            Repeater {
                model: root.extraActions ?? []

                delegate: ContextMenuAction {
                    id: extraActionItem

                    required property var modelData

                    visible: !root.windowPickerOpened
                    theme: root.theme
                    label: String(extraActionItem.modelData.text ?? extraActionItem.modelData.id ?? "Action")
                    actionEnabled: extraActionItem.modelData.enabled !== false

                    onTriggered: root.runExtraAction(extraActionItem.modelData)
                }
            }

            ContextMenuAction {
                visible: !root.windowPickerOpened
                    && (root.individualWindowMovement ? root.nonHiddenWindows().length > 0 : !root.applicationIsHidden())
                theme: root.theme
                label: "Send to hidden workspace"
                actionEnabled: !root.serviceMode && !root.transitionMode

                onTriggered: root.sendToHiddenWorkspace()
            }

            ContextMenuAction {
                visible: !root.windowPickerOpened
                    && (root.individualWindowMovement ? root.hiddenWindows().length > 0 : root.applicationIsHidden())
                theme: root.theme
                label: "Bring here"
                actionEnabled: Hyprland.focusedWorkspace !== null

                onTriggered: root.bringHere()
            }

            ContextMenuAction {
                visible: !root.windowPickerOpened && root.serviceManaged
                theme: root.theme
                label: root.serviceMode ? "Switch to GUI mode" : "Switch to service mode"
                actionEnabled: !root.transitionMode && !modeSwitchProcess.running && !serviceControlProcess.running

                onTriggered: root.switchApplicationMode()
            }

            Rectangle {
                visible: !root.windowPickerOpened
                width: root.implicitWidth - 2 * root.theme.appIndicatorMenuPadding
                height: root.theme.thinBorderWidth
                color: root.theme.separator
            }

            ContextMenuAction {
                visible: !root.windowPickerOpened
                theme: root.theme
                label: "Close application"
                actionEnabled: !root.transitionMode

                onTriggered: root.closeApplication()
            }
        }
    }
}
