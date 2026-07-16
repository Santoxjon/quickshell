import QtQuick
import Quickshell.Services.Pipewire

Item {
    id: root

    required property var theme
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var audio: sink ? sink.audio : null
    readonly property int volume: root.audio ? Math.round(root.audio.volume * 100) : -1
    readonly property int volumeStep: 5
    readonly property int wheelStepAngle: 120
    readonly property string volumeIcon: root.audio && root.audio.muted ? "" : ""
    readonly property string volumeText: !root.audio ? "--%" : root.audio.muted ? "muted" : root.volume + "%"

    signal hovered
    signal unhovered

    function adjustVolume(stepCount: int): void {
        if (!root.audio || stepCount === 0)
            return;

        const nextVolume = Math.max(0, Math.min(100, root.volume + stepCount * root.volumeStep));

        root.audio.volume = nextVolume / 100;
    }

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Row {
        id: row
        spacing: root.theme.audioModuleSpacing

        ModuleText {
            theme: root.theme
            width: root.theme.audioModuleIconWidth

            text: root.volumeIcon
            color: root.theme.rightModuleIcon
        }

        ModuleText {
            theme: root.theme
            width: root.theme.audioModuleValueWidth
            horizontalAlignment: Text.AlignRight

            text: root.volumeText
        }
    }

    MouseArea {
        property int wheelAccumulator: 0

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton

        onEntered: root.hovered()
        onExited: root.unhovered()

        onWheel: wheel => {
            if (!root.audio)
                return;

            wheelAccumulator += wheel.angleDelta.y;

            const stepCount = Math.trunc(wheelAccumulator / root.wheelStepAngle);

            if (stepCount === 0)
                return;

            wheelAccumulator -= stepCount * root.wheelStepAngle;

            root.adjustVolume(stepCount);
        }
    }

    PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }
}
