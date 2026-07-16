import QtQuick

import qs.components

Item {
    id: root

    required property var theme

    readonly property string icon: ""

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    // Display-only placeholder until shutdown behavior is implemented.
    ModuleText {
        id: label

        theme: root.theme
        text: root.icon
        color: root.theme.shutdownButton
    }

    // TODO: Implement shutdown behavior when clicked.
}
