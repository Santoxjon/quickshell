pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Io

import qs.services

PanelWindow {
    id: root

    required property var theme

    property bool opened: false
    property int selectedIndex: -1
    property int secondsRemaining: 0
    property real veilDarkeningProgress: 0
    property real presentationProgress: root.opened ? 1 : 0

    readonly property var actions: [
        {
            "powerAction": PowerActions.Suspend,
            "countdownText": "Sleeping",
            "icon": "sleep-ligth.png"
        },
        {
            "powerAction": PowerActions.PowerOff,
            "countdownText": "Shutting down",
            "icon": "shutdown-light.png"
        },
        {
            "powerAction": PowerActions.Reboot,
            "countdownText": "Restarting",
            "icon": "restart-ligth.png"
        }
    ]
    readonly property bool actionSelected: root.selectedIndex >= 0 && root.selectedIndex < root.actions.length
    readonly property var selectedAction: root.actionSelected ? root.actions[root.selectedIndex] : null
    readonly property string countdownMessage: !root.selectedAction
        ? ""
        : `${root.selectedAction.countdownText} in ${root.secondsRemaining} ${root.secondsRemaining === 1 ? "second" : "seconds"}`
    readonly property real currentVeilOpacity: root.theme.powerMenuVeilOpacity
        + (root.theme.powerMenuCountdownVeilOpacity - root.theme.powerMenuVeilOpacity) * root.veilDarkeningProgress

    visible: root.opened || root.presentationProgress > 0

    anchors {
        top: true
        right: true
        bottom: true
        left: true
    }

    color: "transparent"
    surfaceFormat.opaque: false
    exclusionMode: ExclusionMode.Ignore
    focusable: root.opened

    Behavior on presentationProgress {
        NumberAnimation {
            duration: root.opened ? root.theme.animationDuration : root.theme.fastAnimationDuration
            easing.type: Easing.OutCubic
        }
    }

    onPresentationProgressChanged: {
        if (!root.opened && root.presentationProgress <= 0) {
            root.selectedIndex = -1;
            root.secondsRemaining = 0;
            root.veilDarkeningProgress = 0;
        }
    }

    NumberAnimation {
        id: veilDarkeningAnimation

        target: root
        property: "veilDarkeningProgress"
        from: 0
        to: 1
        duration: root.theme.powerMenuCountdownSeconds * 1000
        easing.type: Easing.Linear
    }

    function openMenu(): void {
        if (root.opened) {
            keyboardScope.forceActiveFocus();
            return;
        }

        root.selectedIndex = -1;
        root.secondsRemaining = 0;
        veilDarkeningAnimation.stop();
        root.veilDarkeningProgress = 0;
        countdownTimer.stop();
        root.opened = true;
        idleTimer.restart();
        Qt.callLater(() => {
            if (root.opened)
                keyboardScope.forceActiveFocus();
        });
    }

    function closeMenu(): void {
        if (!root.opened)
            return;

        idleTimer.stop();
        countdownTimer.stop();
        veilDarkeningAnimation.stop();
        root.opened = false;
    }

    function selectAction(index: int): void {
        if (!root.opened || !Number.isInteger(index) || index < 0 || index >= root.actions.length)
            return;

        if (root.selectedIndex === index) {
            root.executeSelectedAction();
            return;
        }

        if (root.actionSelected)
            return;

        idleTimer.stop();
        root.selectedIndex = index;
        root.secondsRemaining = root.theme.powerMenuCountdownSeconds;
        veilDarkeningAnimation.restart();
        countdownTimer.start();
    }

    function executeSelectedAction(): void {
        const action = root.selectedAction;

        if (!action)
            return;

        root.closeMenu();
        powerActions.execute(action.powerAction);
    }

    PowerActions {
        id: powerActions
    }

    IpcHandler {
        target: "powermenu"

        function open(): void {
            root.openMenu();
        }

        function close(): void {
            root.closeMenu();
        }
    }

    Timer {
        id: idleTimer

        interval: root.theme.powerMenuIdleTimeout
        repeat: false

        onTriggered: root.closeMenu()
    }

    Timer {
        id: countdownTimer

        interval: 1000
        repeat: true

        onTriggered: {
            root.secondsRemaining--;

            if (root.secondsRemaining <= 0)
                root.executeSelectedAction();
        }
    }

    ShaderEffect {
        anchors.fill: parent
        opacity: root.presentationProgress

        property color veilColor: root.theme.powerMenuVeilColor
        property real veilOpacity: root.currentVeilOpacity

        fragmentShader: Qt.resolvedUrl("../shaders/PowerMenuVeil.frag.qsb")
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.opened

        onClicked: root.closeMenu()
    }

    FocusScope {
        id: keyboardScope

        anchors.fill: parent
        focus: root.opened

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape) {
                root.closeMenu();
                event.accepted = true;
            }
        }

        Item {
            id: menuContent

            readonly property real buttonSize: Math.min(root.theme.powerMenuButtonSize, width / 4)

            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.min(Math.max(0, parent.width - root.theme.powerMenuHorizontalMargin * 2), root.theme.powerMenuMaxWidth)
            height: countdownLabel.implicitHeight + root.theme.powerMenuTextSpacing + menuContent.buttonSize
            y: parent.height / 2 - menuContent.buttonSize / 2 - countdownLabel.implicitHeight - root.theme.powerMenuTextSpacing

            Repeater {
                model: root.actions

                delegate: Item {
                    id: actionButton

                    required property var modelData
                    required property int index

                    readonly property bool selected: root.selectedIndex === actionButton.index
                    readonly property bool available: !root.actionSelected || actionButton.selected
                    readonly property real restingCenter: menuContent.width * (actionButton.index + 0.5) / root.actions.length
                    readonly property real targetScale: !actionButton.available
                        ? root.theme.powerMenuHiddenScale
                        : actionMouseArea.containsMouse
                            ? root.theme.powerMenuHoverScale
                            : 1

                    x: (actionButton.selected ? menuContent.width / 2 : actionButton.restingCenter) - width / 2
                    y: countdownLabel.implicitHeight + root.theme.powerMenuTextSpacing
                    width: menuContent.buttonSize
                    height: width
                    opacity: root.opened && actionButton.available ? root.presentationProgress : 0
                    scale: actionButton.targetScale * (root.theme.powerMenuClosedScale + (1 - root.theme.powerMenuClosedScale) * root.presentationProgress)

                    Behavior on x {
                        NumberAnimation {
                            duration: root.theme.animationDuration
                            easing.type: Easing.InOutCubic
                        }
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: root.opened ? root.theme.animationDuration : root.theme.fastAnimationDuration
                            easing.type: Easing.OutCubic
                        }
                    }

                    Behavior on scale {
                        NumberAnimation {
                            duration: root.theme.animationDuration
                            easing.type: Easing.OutBack
                        }
                    }

                    Image {
                        id: actionIcon

                        anchors.fill: parent
                        source: Quickshell.shellDir + "/assets/" + actionButton.modelData.icon
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            autoPaddingEnabled: true
                            shadowEnabled: true
                            shadowColor: root.theme.powerMenuActionColor
                            shadowOpacity: actionMouseArea.containsMouse && actionButton.available ? root.theme.powerMenuShadowOpacity : 0
                            shadowBlur: root.theme.powerMenuShadowBlur

                            Behavior on shadowOpacity {
                                NumberAnimation {
                                    duration: root.theme.fastAnimationDuration
                                }
                            }
                        }
                    }

                    MouseArea {
                        id: actionMouseArea

                        anchors.fill: parent
                        enabled: root.opened && actionButton.available
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: root.selectAction(actionButton.index)
                    }
                }
            }

            Text {
                id: countdownLabel

                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter

                text: root.countdownMessage
                color: root.theme.powerMenuActionColor
                opacity: root.opened && root.actionSelected ? root.presentationProgress : 0
                scale: root.actionSelected ? 1 : root.theme.powerMenuClosedScale
                font.family: root.theme.fontName
                font.pixelSize: root.theme.powerMenuTextSize
                font.weight: Font.Bold

                Behavior on opacity {
                    NumberAnimation {
                        duration: root.opened ? root.theme.animationDuration : root.theme.fastAnimationDuration
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on scale {
                    NumberAnimation {
                        duration: root.theme.animationDuration
                        easing.type: Easing.OutBack
                    }
                }
            }
        }
    }
}
