import QtQuick
import Quickshell

Scope {
    id: root

    property int totalUsage: -1
    property var cores: []

    readonly property string usageText: root.totalUsage < 0 ? "--%" : `${root.totalUsage.toString().padStart(2, "0")}%`

    function normalizeUsage(value): int {
        if (typeof value !== "number" || !Number.isFinite(value))
            return -1;

        return Math.max(0, Math.min(100, Math.round(value)));
    }

    function updateUsage(cpu): void {
        if (!cpu || typeof cpu !== "object") {
            root.totalUsage = -1;
            root.cores = [];
            return;
        }

        const normalizedCores = [];

        const sourceCores = cpu.cores;
        const sourceCoreCount = sourceCores && Number(sourceCores.length);
        if (Number.isFinite(sourceCoreCount) && sourceCoreCount >= 0) {
            for (let index = 0; index < sourceCoreCount; index++) {
                const core = sourceCores[index];
                // Process JSON values can arrive as string-backed variants in
                // QML. Coerce both fields before validating so valid per-core
                // samples are not silently discarded while totalUsage works.
                const id = core && core.id !== null && core.id !== "" ? Number(core.id) : NaN;
                const usageValue = core && core.usage !== null && core.usage !== "" ? Number(core.usage) : NaN;
                const normalizedId = Number.isFinite(id) ? Math.round(id) : -1;
                const usage = root.normalizeUsage(usageValue);

                if (normalizedId >= 0 && usage >= 0)
                    normalizedCores.push({
                        "id": normalizedId,
                        "usage": usage
                    });
            }
        }

        normalizedCores.sort((left, right) => left.id - right.id);

        root.totalUsage = root.normalizeUsage(cpu.totalUsage);
        root.cores = normalizedCores;
    }

    JsonLineProcess {
        logName: "CPU usage"
        running: true
        command: [Quickshell.shellDir + "/scripts/get-cpu-usage.sh"]

        onJsonReceived: cpu => root.updateUsage(cpu)
    }
}
