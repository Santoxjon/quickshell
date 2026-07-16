import QtQuick
import QtQuick.Controls
import Quickshell.Services.Pipewire

Slider {
    id: root

    required property var theme
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var audio: root.sink ? root.sink.audio : null

    width: parent.width
    height: root.theme.audioSliderHeight
    from: 0
    to: 100
    stepSize: 1
    value: root.audio ? Math.round(root.audio.volume * 100) : 0

    onMoved: {
        if (root.audio)
            root.audio.volume = root.value / 100;
    }

    background: Rectangle {
        y: (root.height - height) / 2
        width: root.width
        height: root.theme.audioSliderTrackHeight
        radius: root.theme.cornerRadius
        color: root.theme.sliderEmptyBg

        Rectangle {
            width: root.visualPosition * parent.width
            height: parent.height
            radius: parent.radius
            color: root.theme.sliderBg
        }
    }

    handle: Rectangle {
        width: root.theme.audioSliderHandleWidth
        height: root.theme.audioSliderHandleHeight
        border.width: root.theme.borderWidth
        border.color: root.theme.sliderHandleRectangleBorder
        radius: root.theme.cornerRadius
        x: root.visualPosition * (root.width - width)
        y: (root.height - height) / 2
        color: root.theme.sliderHandleRectangleBg
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }

    PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }
}
