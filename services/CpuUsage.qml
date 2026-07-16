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

        if (Array.isArray(cpu.cores)) {
            for (const core of cpu.cores) {
                const id = core && typeof core.id === "number" ? Math.round(core.id) : -1;
                const usage = core ? root.normalizeUsage(core.usage) : -1;

                if (id >= 0 && usage >= 0)
                    normalizedCores.push({
                        "id": id,
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
