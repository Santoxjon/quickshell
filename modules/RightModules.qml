import QtQuick

import qs.components

Row {
    id: root

    required property var theme

    signal audioHovered
    signal audioUnhovered

    AppIndicator {
        theme: root.theme
    }

    Separator {
        theme: root.theme
    }

    CpuModule {
        theme: root.theme
    }

    Separator {
        theme: root.theme
    }

    MemoryModule {
        theme: root.theme
    }

    Separator {
        theme: root.theme
    }

    TemperatureModule {
        theme: root.theme
    }

    Separator {
        theme: root.theme
    }

    NetworkModule {
        theme: root.theme
    }

    Separator {
        theme: root.theme
    }

    AudioModule {
        theme: root.theme

        onHovered: root.audioHovered()
        onUnhovered: root.audioUnhovered()
    }

    Separator {
        theme: root.theme
    }

    ShutdownModule {
        theme: root.theme
    }
}
