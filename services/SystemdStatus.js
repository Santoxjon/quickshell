function parseProperties(output) {
    const properties = {};

    if (typeof output !== "string")
        return properties;

    for (const line of output.split("\n")) {
        const separatorIndex = line.indexOf("=");
        if (separatorIndex <= 0)
            continue;

        properties[line.slice(0, separatorIndex)] = line.slice(separatorIndex + 1).trim();
    }

    return properties;
}

function formatCompactDuration(totalSeconds) {
    if (!Number.isFinite(totalSeconds))
        return "";

    const elapsedSeconds = Math.max(0, Math.floor(totalSeconds));
    const seconds = elapsedSeconds % 60;

    if (elapsedSeconds < 60)
        return `${seconds}s`;

    const elapsedMinutes = Math.floor(elapsedSeconds / 60);
    const minutes = elapsedMinutes % 60;
    if (elapsedMinutes < 60)
        return `${minutes}m ${seconds}s`;

    const elapsedHours = Math.floor(elapsedMinutes / 60);
    const hours = elapsedHours % 24;
    if (elapsedHours < 24)
        return `${hours}h ${minutes}m ${seconds}s`;

    const days = Math.floor(elapsedHours / 24);
    return `${days}d ${hours}h ${minutes}m ${seconds}s`;
}

function uptimeFromTimestamp(timestamp, nowMilliseconds) {
    if (typeof timestamp !== "string" || !Number.isFinite(nowMilliseconds))
        return "";

    const parts = timestamp.match(/^\S+\s+(\d{4})-(\d{2})-(\d{2})\s+(\d{2}):(\d{2}):(\d{2})/);
    if (!parts)
        return "";

    const startMilliseconds = new Date(
        Number(parts[1]),
        Number(parts[2]) - 1,
        Number(parts[3]),
        Number(parts[4]),
        Number(parts[5]),
        Number(parts[6])
    ).getTime();

    if (!Number.isFinite(startMilliseconds))
        return "";

    return formatCompactDuration((nowMilliseconds - startMilliseconds) / 1000);
}
