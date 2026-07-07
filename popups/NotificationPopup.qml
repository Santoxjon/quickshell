// popups/NotificationPopup.qml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications

PopupWindow {
    id: root

    required property var theme
    required property var anchorWindow
    property Notification notification: null
    property int popupIndex: 0
    property bool closing: false
    property bool autoClosing: false
    property bool entering: true

    anchor.window: anchorWindow
    anchor.rect.x: anchorWindow.width - implicitWidth - 12
    anchor.rect.y: 40 + popupIndex * (implicitHeight + 10)

    visible: root.notification !== null && !root.notification.dismissed

    implicitWidth: 360
    implicitHeight: box.implicitHeight

    color: "transparent"

    function timeoutMs() {
        if (!root.notification)
            return 10000;

        if (root.notification.expireTimeout === 0)
            return -1;

        if (root.notification.expireTimeout > 0)
            return root.notification.expireTimeout;

        return 10000;
    }

    function closePopup(autoClose) {
        if (root.closing || !root.notification)
            return;

        root.autoClosing = autoClose;
        root.closing = true;
        closeTimer.stop();
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onTapped: function (eventPoint, button) {
            if (button === Qt.RightButton) {
                root.closePopup(false);
                return;
            }

            if (button === Qt.LeftButton) {
                if (root.notification && root.notification.actions.length > 0) {
                    root.notification.actions[0].invoke();
                    root.closePopup(false);
                }
            }
        }
    }

    Component.onCompleted: {
        Qt.callLater(function () {
            root.entering = false;
        });
    }

    Timer {
        id: closeTimer
        interval: root.timeoutMs() > 0 ? root.timeoutMs() : 1
        running: root.notification !== null && !root.closing && root.timeoutMs() > 0
        repeat: false

        onTriggered: root.closePopup(true)
    }

    Timer {
        id: dismissAfterAnimation
        interval: 240
        repeat: false

        onTriggered: {
            if (!root.notification)
                return;

            if (root.autoClosing)
                root.notification.expire();
            else
                root.notification.dismiss();
        }
    }

    onClosingChanged: {
        if (root.closing)
            dismissAfterAnimation.start();
    }

    Rectangle {
        id: box
        anchors.fill: parent
        radius: 5
        color: root.theme.bg
        border.width: 2
        border.color: root.theme.border

        implicitHeight: content.implicitHeight + 16

        Rectangle {
            anchors.left: box.left
            anchors.top: box.top
            anchors.bottom: box.bottom

            width: 7
            color: root.theme.border
            topLeftRadius: 5
            bottomLeftRadius: 5
        }

        transform: Translate {
            x: root.entering ? root.implicitWidth + 40 : (root.closing ? root.implicitWidth + 40 : 0)

            Behavior on x {
                NumberAnimation {
                    duration: 220
                    easing.type: Easing.OutCubic
                }
            }
        }

        RowLayout {
            id: content
            anchors.fill: parent
            anchors.margins: 8
            anchors.leftMargin: 15
            spacing: 16

            implicitHeight: Math.max(icon.visible ? icon.Layout.preferredHeight : 0, textColumn.implicitHeight)

            Image {
                id: icon

                Layout.preferredWidth: 96
                Layout.preferredHeight: 96
                Layout.alignment: Qt.AlignVCenter

                source: root.notification ? (root.notification.image || root.notification.appIcon) : ""

                fillMode: Image.PreserveAspectFit
                smooth: true
                visible: source !== ""
            }

            ColumnLayout {
                id: textColumn

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 4

                Text {
                    Layout.fillWidth: true
                    text: root.notification ? root.notification.summary.trim() : ""
                    color: root.theme.fg
                    font.pixelSize: 15
                    font.bold: true
                    horizontalAlignment: Text.AlignLeft
                }

                Text {
                    Layout.fillWidth: true
                    text: root.notification ? root.notification.body.replace(/\s+$/, "") : ""
                    color: root.theme.fg
                    wrapMode: Text.WordWrap
                    font.pixelSize: 13
                    horizontalAlignment: Text.AlignLeft
                }

                Repeater {
                    model: root.notification ? root.notification.actions : []

                    delegate: Text {
                        required property var modelData

                        Layout.fillWidth: true
                        text: modelData.text
                        color: root.theme.fg
                        font.pixelSize: 13
                        font.bold: true
                        horizontalAlignment: Text.AlignLeft

                        TapHandler {
                            acceptedButtons: Qt.LeftButton

                            onTapped: {
                                modelData.invoke();
                                root.closePopup(false);
                            }
                        }
                    }
                }
            }
        }
    }
}
