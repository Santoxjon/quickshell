import QtQuick
import Quickshell
import QtQuick.Controls
import Quickshell.Services.Pipewire
import QtQuick.Shapes

import "../components"

PopupWindow {
    id: root

    required property var theme
    required property var anchorWindow
    property bool opened: false
    property bool animating: false

    visible: opened || animating

    anchor.window: anchorWindow
    anchor.rect.x: anchorWindow.width - implicitWidth - 30
    anchor.rect.y: root.theme.barHeight - 2

    implicitWidth: 320
    implicitHeight: Pipewire.nodes.values.filter(node => node.isSink && node.name && node.name.startsWith("alsa_output.")).length * 36 + 12 + 10 + 26 + 28 + 12 + 40
    color: "transparent"

    readonly property bool fullyOpened: box.height === root.implicitHeight && root.opened

    Item {
        id: box

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        height: root.opened ? root.implicitHeight : 0
        clip: true

        property int lip: 18
        property int radius: 5

        Behavior on height {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutCubic
            }
        }

        Shape {
            anchors.fill: parent
            antialiasing: true

            layer.enabled: true
            layer.samples: 8

            ShapePath {
                strokeWidth: 0
                fillColor: root.theme.bg

                startX: 0
                startY: 0

                PathLine {
                    x: box.width
                    y: 0
                }

                // esquina superior derecha tipo cazuela
                PathCubic {
                    x: box.width - box.lip
                    y: box.lip
                    control1X: box.width - 4
                    control1Y: 0
                    control2X: box.width - box.lip
                    control2Y: 4
                }

                PathLine {
                    x: box.width - box.lip
                    y: box.height - box.radius
                }

                PathQuad {
                    x: box.width - box.lip - box.radius
                    y: box.height
                    controlX: box.width - box.lip
                    controlY: box.height
                }

                PathLine {
                    x: box.lip + box.radius
                    y: box.height
                }

                PathQuad {
                    x: box.lip
                    y: box.height - box.radius
                    controlX: box.lip
                    controlY: box.height
                }

                PathLine {
                    x: box.lip
                    y: box.lip
                }

                // esquina superior izquierda tipo cazuela
                PathCubic {
                    x: 0
                    y: 0
                    control1X: box.lip
                    control1Y: 4
                    control2X: 4
                    control2Y: 0
                }
            }
        }

        Shape {
            anchors.fill: parent
            antialiasing: true
            layer.enabled: true
            layer.samples: 8

            opacity: root.fullyOpened ? 1.0 : 0.0

            Behavior on opacity {
                NumberAnimation {
                    duration: root.fullyOpened ? 0 : 500
                    easing.type: Easing.OutCubic
                }
            }

            ShapePath {
                strokeWidth: 2
                strokeColor: root.theme.topBarBottomBorder
                fillColor: "transparent"

                startX: 0
                startY: 0

                PathMove {
                    x: box.width
                    y: 0
                }

                PathCubic {
                    x: box.width - box.lip
                    y: box.lip
                    control1X: box.width - 4
                    control1Y: 0
                    control2X: box.width - box.lip
                    control2Y: 4
                }

                PathLine {
                    x: box.width - box.lip
                    y: box.height - box.radius - 1
                }

                // esquina inferior derecha: subimos el controlY y el y final 1 píxel
                PathQuad {
                    x: box.width - box.lip - box.radius
                    y: box.height - 1
                    controlX: box.width - box.lip
                    controlY: box.height - 1
                }

                // borde inferior abajo: se mantiene a la altura de box.height - 1
                PathLine {
                    x: box.lip + box.radius
                    y: box.height - 1
                }

                // esquina inferior izquierda: subimos el controlY y el y final 1 píxel
                PathQuad {
                    x: box.lip
                    y: box.height - box.radius - 1
                    controlX: box.lip
                    controlY: box.height - 1
                }

                PathLine {
                    x: box.lip
                    y: box.lip
                }

                PathCubic {
                    x: 0
                    y: 0
                    control1X: box.lip
                    control1Y: 4
                    control2X: 4
                    control2Y: 0
                }
            }
        }

        Column {
            anchors.fill: parent
            anchors.leftMargin: 12 + box.lip
            anchors.rightMargin: 12 + box.lip
            anchors.topMargin: 12
            anchors.bottomMargin: 12
            spacing: 10

            opacity: box.height / root.implicitHeight

            ModuleText {
                theme: root.theme
                text: "Salidas"
            }

            Repeater {
                model: Pipewire.nodes.values.filter(node => node.isSink && node.name && node.name.startsWith("alsa_output."))

                delegate: Item {
                    width: parent.width
                    height: 26

                    readonly property bool isCurrent: modelData === Pipewire.defaultAudioSink

                    ModuleText {
                        anchors.verticalCenter: parent.verticalCenter
                        theme: root.theme
                        text: (isCurrent ? "● " : "○ ") + modelData.description

                        MouseArea {
                            anchors.fill: parent
                            onClicked: Pipewire.preferredDefaultAudioSink = modelData
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 2
                color: root.theme.border
            }

            ModuleText {
                theme: root.theme
                text: "Volumen " + Math.round(volumeSlider.value) + "%"
            }

            Slider {
                id: volumeSlider

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
                    color: root.theme.sliderEmptyBg

                    Rectangle {
                        width: volumeSlider.visualPosition * parent.width
                        height: parent.height
                        radius: parent.radius
                        color: root.theme.sliderBg
                    }
                }

                handle: Rectangle {
                    width: 20
                    height: 25
                    border.width: 2
                    border.color: root.theme.sliderHandleRectangleBorder
                    radius: 5

                    x: volumeSlider.visualPosition * (volumeSlider.width - width)
                    y: volumeSlider.height / 2 - height / 2

                    color: root.theme.sliderHandleRectangleBg
                }

                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }
    }
    HoverHandler {
        onHoveredChanged: {
            if (hovered)
                root.entered();
            else
                root.exited();
        }
    }

    onOpenedChanged: {
        if (opened) {
            animating = true;
        } else {
            closeTimer.restart();
        }
    }

    Timer {
        id: closeTimer
        interval: 230
        repeat: false
        onTriggered: root.animating = false
    }

    PwObjectTracker {
        objects: Pipewire.nodes.values
    }

    signal entered
    signal exited
}
