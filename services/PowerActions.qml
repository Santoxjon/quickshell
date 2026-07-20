pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io

Scope {
    id: root

    enum Action {
        Suspend,
        PowerOff,
        Reboot
    }

    function execute(action: int): void {
        let command;

        switch (action) {
        case PowerActions.Suspend:
            command = ["systemctl", "suspend"];
            break;
        case PowerActions.PowerOff:
            command = ["systemctl", "poweroff"];
            break;
        case PowerActions.Reboot:
            command = ["systemctl", "reboot"];
            break;
        default:
            console.warn(`PowerActions: unsupported action ${action}`);
            return;
        }

        actionProcess.command = command;
        actionProcess.startDetached();
    }

    Process {
        id: actionProcess
    }
}
