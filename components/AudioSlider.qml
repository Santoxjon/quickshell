// components/AudioSlider.qml
import QtQuick
import QtQuick.Controls
import Quickshell.Services.Pipewire

Slider {
    id: volumeSlider

    required property var theme
    width: parent.width
    height: 28
    from: 0
    to: 100
    stepSize: 1

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var audio: sink ? sink.audio : null
    value: audio ? Math.round(audio.volume * 100) : 0

    onMoved: {
        if (audio)
            audio.volume = value / 100;
    }

    background: Rectangle {
        x: 0
        y: volumeSlider.height / 2 - height / 2
        width: volumeSlider.width
        height: 15
        radius: 5
        color: volumeSlider.theme.sliderEmptyBg

        Rectangle {
            width: volumeSlider.visualPosition * parent.width
            height: parent.height
            radius: parent.radius
            color: volumeSlider.theme.sliderBg
        }
    }

    handle: Rectangle {
        width: 20
        height: 25
        border.width: 2
        border.color: volumeSlider.theme.sliderHandleRectangleBorder
        radius: 5
        x: volumeSlider.visualPosition * (volumeSlider.width - width)
        y: volumeSlider.height / 2 - height / 2
        color: volumeSlider.theme.sliderHandleRectangleBg
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
}
