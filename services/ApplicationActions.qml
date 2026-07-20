import Quickshell

Scope {
    id: root

    function launch(application: DesktopEntry): void {
        if (!application) {
            console.warn("ApplicationActions: cannot launch an empty desktop entry");
            return;
        }

        application.execute();
    }
}
