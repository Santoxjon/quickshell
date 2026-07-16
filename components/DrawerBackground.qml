import QtQuick

Item {
    id: root

    required property var theme
    property bool opened: false

    readonly property int lip: root.theme.drawerLip
    readonly property bool fullyOpened: root.opened && root.height === root.implicitHeight

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right

    height: root.opened ? root.implicitHeight : 0
    clip: true

    Behavior on height {
        NumberAnimation {
            duration: root.theme.animationDuration
            easing.type: Easing.OutCubic
        }
    }

    DrawerShape {
        anchors.fill: parent
        lip: root.lip
        cornerRadius: root.theme.cornerRadius
        fillColor: root.theme.bg
    }

    DrawerShape {
        anchors.fill: parent
        lip: root.lip
        cornerRadius: root.theme.cornerRadius
        fillColor: "transparent"
        strokeColor: root.theme.topBarBottomBorder
        strokeWidth: root.theme.accentBorderWidth
        bottomInset: root.theme.drawerBorderInset
        opacity: root.fullyOpened ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: root.fullyOpened ? 0 : root.theme.animationDuration
                easing.type: Easing.OutCubic
            }
        }
    }
}
