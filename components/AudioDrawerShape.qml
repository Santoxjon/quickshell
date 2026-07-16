import QtQuick
import QtQuick.Shapes

Shape {
    id: root

    required property real lip
    required property real cornerRadius
    required property color fillColor
    property color strokeColor: "transparent"
    property real strokeWidth: 0
    property real bottomInset: 0

    readonly property real curveControlOffset: Math.max(0, root.cornerRadius - 1)

    antialiasing: true
    layer.enabled: true
    layer.samples: 8

    ShapePath {
        strokeWidth: root.strokeWidth
        strokeColor: root.strokeColor
        fillColor: root.fillColor
        startX: root.width
        startY: 0

        PathCubic {
            x: root.width - root.lip
            y: root.lip
            control1X: root.width - root.curveControlOffset
            control1Y: 0
            control2X: root.width - root.lip
            control2Y: root.curveControlOffset
        }

        PathLine {
            x: root.width - root.lip
            y: root.height - root.cornerRadius - root.bottomInset
        }

        PathQuad {
            x: root.width - root.lip - root.cornerRadius
            y: root.height - root.bottomInset
            controlX: root.width - root.lip
            controlY: root.height - root.bottomInset
        }

        PathLine {
            x: root.lip + root.cornerRadius
            y: root.height - root.bottomInset
        }

        PathQuad {
            x: root.lip
            y: root.height - root.cornerRadius - root.bottomInset
            controlX: root.lip
            controlY: root.height - root.bottomInset
        }

        PathLine {
            x: root.lip
            y: root.lip
        }

        PathCubic {
            x: 0
            y: 0
            control1X: root.lip
            control1Y: root.curveControlOffset
            control2X: root.curveControlOffset
            control2Y: 0
        }
    }
}
