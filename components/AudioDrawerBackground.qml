// components/AudioDrawerBackground.qml
import QtQuick
import QtQuick.Shapes

Item {
    id: box

    required property var theme
    property bool opened: false
    property int implicitHeight: 300

    property int lip: 18
    property int radius: 5

    readonly property bool fullyOpened: height === implicitHeight && opened

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right

    height: opened ? implicitHeight : 0
    clip: true

    Behavior on height {
        NumberAnimation {
            duration: 220
            easing.type: Easing.OutCubic
        }
    }

    // Fondo del Drawer
    Shape {
        anchors.fill: parent
        antialiasing: true
        layer.enabled: true
        layer.samples: 8

        ShapePath {
            strokeWidth: 0
            fillColor: box.theme.bg
            startX: 0
            startY: 0
            PathLine {
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

    // Borde del Drawer
    Shape {
        anchors.fill: parent
        antialiasing: true
        layer.enabled: true
        layer.samples: 8
        opacity: box.fullyOpened ? 1.0 : 0.0

        Behavior on opacity {
            NumberAnimation {
                duration: box.fullyOpened ? 0 : 200
                easing.type: Easing.OutCubic
            }
        }

        ShapePath {
            strokeWidth: 3
            strokeColor: box.theme.topBarBottomBorder
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
            PathQuad {
                x: box.width - box.lip - box.radius
                y: box.height - 1
                controlX: box.width - box.lip
                controlY: box.height - 1
            }
            PathLine {
                x: box.lip + box.radius
                y: box.height - 1
            }
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
}
