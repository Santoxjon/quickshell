import QtQuick

import qs.components

Row {
    id: root

    required property var theme
    required property var cpuUsage

    readonly property Item cpuAnchorItem: cpuModule
    readonly property Item networkAnchorItem: networkModule
    readonly property alias networkModuleItem: networkModule

    signal audioHovered
    signal audioUnhovered
    signal cpuHovered
    signal cpuUnhovered
    signal networkHovered
    signal networkUnhovered
    signal shutdownRequested

    AppIndicator {
        theme: root.theme
    }

    Separator {
        theme: root.theme
    }

    CpuModule {
        id: cpuModule

        theme: root.theme
        cpuUsage: root.cpuUsage

        onHovered: root.cpuHovered()
        onUnhovered: root.cpuUnhovered()
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
        id: networkModule

        theme: root.theme

        onHovered: root.networkHovered()
        onUnhovered: root.networkUnhovered()
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

        onActivated: root.shutdownRequested()
    }
}
