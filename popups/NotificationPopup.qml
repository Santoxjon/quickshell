pragma ComponentBehavior: Bound

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

    readonly property int defaultTimeout: 10000
    readonly property int dismissDelay: root.theme.animationDuration + 20
    readonly property int effectiveTimeout: {
        if (!root.notification)
            return root.defaultTimeout;

        if (root.notification.expireTimeout === 0)
            return -1;

        return root.notification.expireTimeout > 0
            ? root.notification.expireTimeout
            : root.defaultTimeout;
    }

    anchor.window: root.anchorWindow
    anchor.rect.x: root.anchorWindow.width - root.implicitWidth - root.theme.notificationScreenMargin
    anchor.rect.y: root.theme.notificationTopOffset
        + root.popupIndex * (root.implicitHeight + root.theme.notificationGap)

    visible: root.notification !== null && !root.notification.dismissed

    implicitWidth: root.theme.notificationWidth
    implicitHeight: box.implicitHeight

    color: "transparent"

    function closePopup(autoClose: bool): void {
        if (root.closing || !root.notification)
            return;

        root.autoClosing = autoClose;
        root.closing = true;
        closeTimer.stop();
        dismissAfterAnimation.restart();
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: root.notification && root.notification.actions.length > 0
            ? Qt.PointingHandCursor
            : Qt.ArrowCursor

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

        interval: root.effectiveTimeout > 0 ? root.effectiveTimeout : 1
        running: root.notification !== null && !root.closing && root.effectiveTimeout > 0

        onTriggered: root.closePopup(true)
    }

    Timer {
        id: dismissAfterAnimation

        interval: root.dismissDelay

        onTriggered: {
            if (!root.notification)
                return;

            if (root.autoClosing)
                root.notification.expire();
            else
                root.notification.dismiss();
        }
    }

    Rectangle {
        id: box

        anchors.fill: parent

        radius: root.theme.cornerRadius
        color: root.theme.bg
        border.width: root.theme.borderWidth
        border.color: root.theme.border

        implicitHeight: content.implicitHeight + 2 * root.theme.notificationContentPadding

        Rectangle {
            anchors.left: box.left
            anchors.top: box.top
            anchors.bottom: box.bottom

            width: root.theme.notificationAccentWidth
            color: root.theme.border
            topLeftRadius: root.theme.cornerRadius
            bottomLeftRadius: root.theme.cornerRadius
        }

        transform: Translate {
            x: root.entering || root.closing
                ? root.implicitWidth + root.theme.notificationHiddenOffset
                : 0

            Behavior on x {
                NumberAnimation {
                    duration: root.theme.animationDuration
                    easing.type: Easing.OutCubic
                }
            }
        }

        RowLayout {
            id: content

            anchors.fill: parent
            anchors.margins: root.theme.notificationContentPadding
            anchors.leftMargin: root.theme.notificationContentLeftPadding

            spacing: root.theme.notificationContentSpacing

            implicitHeight: Math.max(iconContainer.Layout.preferredHeight, textColumn.implicitHeight)

            Item {
                id: iconContainer

                Layout.preferredWidth: root.theme.notificationIconSize
                Layout.preferredHeight: root.theme.notificationIconSize
                Layout.alignment: Qt.AlignVCenter

                Image {
                    id: notificationIcon

                    anchors.fill: parent

                    source: root.notification ? (root.notification.image || root.notification.appIcon) : ""

                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    visible: source.toString() !== ""
                }

                Text {
                    anchors.fill: parent

                    visible: !notificationIcon.visible || notificationIcon.status === Image.Error

                    text: ""
                    color: root.theme.fg
                    font.family: root.theme.fontName
                    font.pixelSize: root.theme.notificationIconSize
                    textFormat: Text.PlainText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            ColumnLayout {
                id: textColumn

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: root.theme.notificationTextSpacing

                Text {
                    Layout.fillWidth: true
                    text: root.notification ? root.notification.summary.trim() : ""
                    color: root.theme.fg
                    font.family: root.theme.fontName
                    font.pixelSize: root.theme.smallFontSize
                    font.bold: true
                    textFormat: Text.PlainText
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignLeft
                }

                Text {
                    Layout.fillWidth: true
                    text: root.notification ? root.notification.body.replace(/\s+$/, "") : ""
                    color: root.theme.fg
                    wrapMode: Text.WordWrap
                    font.family: root.theme.fontName
                    font.pixelSize: root.theme.captionFontSize
                    horizontalAlignment: Text.AlignLeft
                }

                Repeater {
                    model: root.notification ? root.notification.actions : []

                    delegate: Text {
                        id: actionLabel

                        required property var modelData

                        Layout.fillWidth: true
                        text: actionLabel.modelData.text
                        color: root.theme.fg
                        font.family: root.theme.fontName
                        font.pixelSize: root.theme.captionFontSize
                        font.bold: true
                        textFormat: Text.PlainText
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignLeft

                        TapHandler {
                            acceptedButtons: Qt.LeftButton
                            cursorShape: Qt.PointingHandCursor

                            onTapped: {
                                actionLabel.modelData.invoke();
                                root.closePopup(false);
                            }
                        }
                    }
                }
            }
        }
    }
}
