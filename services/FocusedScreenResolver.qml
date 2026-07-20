import Quickshell
import Quickshell.Hyprland

Scope {
    id: root

    function resolve(): var {
        const focusedMonitor = Hyprland.focusedMonitor;

        if (!focusedMonitor)
            return null;

        for (const candidate of Quickshell.screens) {
            const monitor = Hyprland.monitorFor(candidate);

            if (monitor && monitor.name === focusedMonitor.name)
                return candidate;
        }

        return null;
    }
}
