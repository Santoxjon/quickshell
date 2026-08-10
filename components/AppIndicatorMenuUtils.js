.pragma library

function applicationWindows(application) {
    return application && Array.isArray(application.windows) ? application.windows : [];
}

function windowIsHidden(appWindow, hiddenWorkspaceId) {
    return Boolean(appWindow) && Number(appWindow.workspaceId) === hiddenWorkspaceId;
}

function applicationIsHidden(application, hiddenWorkspaceId) {
    const windows = applicationWindows(application);
    return windows.length > 0 && windows.every(appWindow => windowIsHidden(appWindow, hiddenWorkspaceId));
}

function nonHiddenWindows(application, hiddenWorkspaceId) {
    return applicationWindows(application).filter(appWindow => !windowIsHidden(appWindow, hiddenWorkspaceId));
}

function hiddenWindows(application, hiddenWorkspaceId) {
    return applicationWindows(application).filter(appWindow => windowIsHidden(appWindow, hiddenWorkspaceId));
}

function focusWorkspaceId(application, individualWindowMovement, hiddenWorkspaceId) {
    if (!application)
        return -1;

    if (individualWindowMovement) {
        const visibleWindows = nonHiddenWindows(application, hiddenWorkspaceId);
        return visibleWindows.length > 0 ? Number(visibleWindows[0].workspaceId) : -1;
    }

    return applicationIsHidden(application, hiddenWorkspaceId) ? -1 : Number(application.workspaceId);
}

function windowPickerCandidates(action, application, hiddenWorkspaceId) {
    if (action === "send")
        return nonHiddenWindows(application, hiddenWorkspaceId);

    if (action === "bring")
        return hiddenWindows(application, hiddenWorkspaceId);

    return [];
}

function parseAmuleStatus(output) {
    const text = String(output == null ? "" : output);
    const serverLine = text.match(/^\s*>\s*eD2k:\s*(.+)$/mi);
    const kadLine = text.match(/^\s*>\s*Kad:\s*(.+)$/mi);
    const downloadLine = text.match(/^\s*>\s*Download:\s*(.+)$/mi);
    const uploadLine = text.match(/^\s*>\s*Upload:\s*(.+)$/mi);
    const status = {
        server: "Disconnected",
        kad: "Disconnected",
        download: downloadLine ? downloadLine[1].trim() : "--",
        upload: uploadLine ? uploadLine[1].trim() : "--"
    };

    if (serverLine) {
        const serverValue = serverLine[1].trim();
        const connectedServer = serverValue.match(/^Connected to\s+(.+?)(?:\s+\[[^\]]+\])?\s+with\s+(HighID|LowID)\s*$/i);

        if (connectedServer) {
            const idType = connectedServer[2].toLowerCase() === "highid" ? "HighID" : "LowID";
            status.server = `${connectedServer[1].trim()} · ${idType}`;
        }
    }

    if (kadLine) {
        const kadValue = kadLine[1].trim();

        if (!/(?:disconnected|not connected)/i.test(kadValue) && /connected/i.test(kadValue))
            status.kad = "Kad: OK";
    }

    return status;
}

function windowPickerLabel(appWindow, index, applicationName) {
    const title = String(appWindow && appWindow.title != null ? appWindow.title : "").trim();
    const displayTitle = title.length > 0 ? title : `${applicationName} window ${index + 1}`;
    const workspaceId = appWindow && appWindow.workspaceId != null ? appWindow.workspaceId : "?";
    return `${index + 1}. ${displayTitle}  ·  WS ${workspaceId}`;
}

function validWindowAddresses(windows) {
    if (!Array.isArray(windows))
        return [];

    return windows
        .map(appWindow => String(appWindow && appWindow.address != null ? appWindow.address : ""))
        .filter(address => /^0x[0-9a-f]+$/i.test(address));
}

function animationConfiguration(speed) {
    return [
        `hl.animation({ leaf = "windowsIn", enabled = true, speed = ${speed}, bezier = "default" })`,
        `hl.animation({ leaf = "windowsOut", enabled = true, speed = ${speed}, bezier = "default" })`,
        `hl.animation({ leaf = "windowsMove", enabled = true, speed = ${speed}, bezier = "default" })`,
        `hl.animation({ leaf = "fadeIn", enabled = true, speed = ${speed}, bezier = "default" })`,
        `hl.animation({ leaf = "fadeOut", enabled = true, speed = ${speed}, bezier = "default" })`
    ].join("; ");
}
