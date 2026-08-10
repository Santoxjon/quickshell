pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

import "SystemdStatus.js" as SystemdStatus

Scope {
    id: root

    required property var activeApplications
    required property string applicationId
    required property string serviceUnit
    property int modeSwitchGracePeriod: 5000
    property int modeSwitchMaximumHold: 15000

    readonly property var serviceState: systemdStatus.active ? {
        "id": root.applicationId,
        "mode": "service",
        "workspaceId": -1,
        "windows": []
    } : null
    readonly property var transitionState: root.pendingMode.length > 0 ? {
        "id": root.applicationId,
        "mode": "transition",
        "targetMode": root.pendingMode,
        "workspaceId": -1,
        "windows": []
    } : null

    property string pendingMode: ""
    property bool closePending: false

    function applicationState(): var {
        if (root.closePending)
            return null;

        if (root.transitionState)
            return root.transitionState;

        for (const application of root.activeApplications) {
            if (application.id === root.applicationId)
                return application;
        }

        return root.serviceState;
    }

    function guiIsActive(): bool {
        for (const application of root.activeApplications) {
            if (application.id === root.applicationId)
                return true;
        }

        return false;
    }

    function beginModeTransition(targetMode: string): void {
        root.pendingMode = targetMode;
        modeSwitchGraceTimer.interval = root.modeSwitchMaximumHold;
        modeSwitchGraceTimer.restart();
    }

    function finishModeTransition(targetMode: string, succeeded: bool): void {
        if (root.pendingMode !== targetMode)
            return;

        if (!succeeded) {
            root.pendingMode = "";
            modeSwitchGraceTimer.stop();
            return;
        }

        root.updateModeTransition();

        if (root.pendingMode.length > 0) {
            modeSwitchGraceTimer.interval = root.modeSwitchGracePeriod;
            modeSwitchGraceTimer.restart();
        }
    }

    function updateModeTransition(): void {
        if (root.pendingMode === "gui" && root.guiIsActive()) {
            root.pendingMode = "";
            modeSwitchGraceTimer.stop();
        } else if (root.pendingMode === "service" && systemdStatus.active) {
            root.pendingMode = "";
            modeSwitchGraceTimer.stop();
        }
    }

    function beginServiceClose(): void {
        root.closePending = true;
    }

    function finishServiceClose(succeeded: bool): void {
        if (!succeeded || !systemdStatus.active)
            root.closePending = false;
    }

    function showStatus(): void {
        if (!statusProcess.running)
            statusProcess.running = true;
    }

    function sendStatusNotification(querySucceeded: bool, output: string): void {
        const properties = SystemdStatus.parseProperties(output);
        const activeState = properties.ActiveState ?? "unknown";
        const subState = properties.SubState ?? "unknown";
        const uptime = SystemdStatus.uptimeFromTimestamp(properties.ActiveEnterTimestamp ?? "", Date.now());
        const runningCorrectly = querySucceeded && activeState === "active" && subState === "running";
        let body = "running in service mode.\n";

        if (!querySucceeded) {
            body += "Status: unable to check the service.";
        } else if (runningCorrectly) {
            body += "Status: active and running";
        } else {
            body += `Status: not running correctly (${activeState}/${subState}).`;
        }

        if (querySucceeded && activeState === "active" && uptime.length > 0)
            body += `\nActive for: ${uptime}.`;

        if (notificationProcess.running)
            return;

        notificationProcess.command = [
            "notify-send",
            "--app-name=aMule",
            "--icon=" + Quickshell.shellDir + "/assets/amule.png",
            "aMule service mode",
            body
        ];
        notificationProcess.running = true;
    }

    onActiveApplicationsChanged: root.updateModeTransition()

    SystemdUnitStatus {
        id: systemdStatus

        unitName: root.serviceUnit

        onActiveChanged: {
            if (!active)
                root.closePending = false;

            root.updateModeTransition();
        }
    }

    Process {
        id: statusProcess

        command: [
            "systemctl",
            "show",
            root.serviceUnit,
            "--property=ActiveState",
            "--property=SubState",
            "--property=ActiveEnterTimestamp",
            "--no-pager"
        ]

        stdout: StdioCollector {
            id: statusOutput
        }

        stderr: SplitParser {
            onRead: line => console.warn(`aMule service status: ${line}`)
        }

        onExited: function (exitCode) {
            root.sendStatusNotification(exitCode === 0, statusOutput.text);
        }
    }

    Process {
        id: notificationProcess

        stderr: SplitParser {
            onRead: line => console.warn(`aMule service notification: ${line}`)
        }
    }

    Timer {
        id: modeSwitchGraceTimer

        interval: root.modeSwitchGracePeriod
        repeat: false

        onTriggered: root.pendingMode = ""
    }
}
