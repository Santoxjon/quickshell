import QtQuick
import Quickshell.Services.Pipewire

Item {
    id: root

    required property var theme

    signal hovered
    signal unhovered

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var audio: sink ? sink.audio : null
    readonly property int volume: root.audio ? Math.round(root.audio.volume * 100) : -1

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Row {
        id: row
        spacing: 6

        ModuleText {
            theme: root.theme
            width: 23

            text: root.audio && root.audio.muted ? "" : ""
        }

        ModuleText {
            theme: root.theme
            width: 42
            horizontalAlignment: Text.AlignRight

            text: !root.audio ? "--%" : root.audio.muted ? "muted" : root.volume + "%"
        }
    }

    MouseArea {
        property int wheelAccum: 0
        anchors.fill: parent
        hoverEnabled: true

        onEntered: root.hovered()
        onExited: root.unhovered()

        onClicked: root.clicked()

        onWheel: wheel => {
            if (!root.audio)
                return;

            wheelAccum += wheel.angleDelta.y;

            if (Math.abs(wheelAccum) < 120)
                return;

            const delta = wheelAccum > 0 ? 5 : -5;
            wheelAccum = 0;

            const newVolume = Math.max(0, Math.min(100, root.volume + delta));

            root.audio.volume = newVolume / 100;
        }
    }

    PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }
}
