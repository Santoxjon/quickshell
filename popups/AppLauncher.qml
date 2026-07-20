pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

import qs.components
import qs.services

PanelWindow {
    id: root

    required property var theme

    property bool opened: false
    property int selectedIndex: -1
    property DesktopEntry pendingApplication: null
    property var displayedApplications: []
    property real presentationProgress: root.opened ? 1 : 0
    property real queryPresentationProgress: root.hasQuery ? 1 : 0

    readonly property bool hasQuery: applicationsModel.hasQuery
    readonly property bool selectionValid: root.selectedIndex >= 0 && root.selectedIndex < root.displayedApplications.length
    readonly property DesktopEntry selectedApplication: root.selectionValid ? root.displayedApplications[root.selectedIndex] : null

    onHasQueryChanged: {
        if (root.hasQuery)
            return;

        root.selectedIndex = -1;

        if (!resultsContainer.visible)
            root.displayedApplications = [];
    }

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

    Behavior on queryPresentationProgress {
        NumberAnimation {
            duration: root.opened ? root.theme.animationDuration : root.theme.fastAnimationDuration
            easing.type: Easing.OutCubic
        }
    }

    onPresentationProgressChanged: {
        if (!root.opened && root.presentationProgress <= 0) {
            const application = root.pendingApplication;
            root.pendingApplication = null;
            searchInput.clear();
            root.selectedIndex = -1;

            if (application)
                applicationActions.launch(application);
        }
    }

    function openLauncher(): void {
        if (root.opened) {
            searchInput.forceActiveFocus();
            return;
        }

        root.pendingApplication = null;

        const targetScreen = focusedScreenResolver.resolve();

        if (targetScreen)
            root.screen = targetScreen;

        searchInput.clear();
        root.selectedIndex = -1;
        root.opened = true;
        Qt.callLater(() => {
            if (root.opened)
                searchInput.forceActiveFocus();
        });
    }

    function closeLauncher(): void {
        if (!root.opened)
            return;

        root.opened = false;
    }

    function moveSelection(direction: int): void {
        const resultCount = resultsView.count;
        const wasAtEnd = resultsView.atYEnd;
        const step = Math.sign(direction);

        if (resultCount === 0 || step === 0)
            return;

        if (root.selectedIndex < 0 || root.selectedIndex >= resultCount)
            root.selectedIndex = step > 0 ? 0 : resultCount - 1;
        else
            root.selectedIndex = (root.selectedIndex + step + resultCount) % resultCount;

        resultsView.positionViewAtIndex(root.selectedIndex, ListView.Contain);

        if (step < 0 && wasAtEnd) {
            const rowStep = root.theme.launcherResultHeight + root.theme.launcherResultSpacing;

            resultsView.contentY = Math.max(resultsView.originY, resultsView.contentY - rowStep);
        }
    }

    function selectFirstResult(): void {
        root.selectedIndex = root.hasQuery && root.displayedApplications.length > 0 ? 0 : -1;

        if (root.selectedIndex === 0)
            resultsView.positionViewAtBeginning();
    }

    function scrollResults(wheelDelta: real): void {
        if (!Number.isFinite(wheelDelta) || wheelDelta === 0)
            return;

        const minimumY = resultsView.originY;
        const maximumY = resultsContainer.maximumContentY;
        const targetY = resultsView.contentY - Math.sign(wheelDelta) * root.theme.launcherScrollStep;

        resultsView.cancelFlick();
        resultsView.contentY = Math.max(minimumY, Math.min(maximumY, targetY));
    }

    function activateApplication(application: DesktopEntry): void {
        if (!root.opened || !application)
            return;

        root.pendingApplication = application;
        root.closeLauncher();
    }

    ApplicationActions {
        id: applicationActions
    }

    FocusedScreenResolver {
        id: focusedScreenResolver
    }

    GlobalShortcut {
        name: "launcher"
        description: "Open the application launcher"

        onPressed: root.openLauncher()
    }

    IpcHandler {
        target: "launcher"

        function open(): void {
            root.openLauncher();
        }

        function close(): void {
            root.closeLauncher();
        }
    }

    Connections {
        target: Hyprland

        function onFocusedWorkspaceChanged(): void {
            if (root.opened)
                root.closeLauncher();
        }
    }

    Timer {
        id: selectionUpdateTimer

        interval: 0
        repeat: false

        onTriggered: root.selectFirstResult()
    }

    ApplicationSearchModel {
        id: applicationsModel

        searchText: searchInput.text

        onValuesChanged: {
            if (!root.hasQuery)
                return;

            root.displayedApplications = [...applicationsModel.values];
            selectionUpdateTimer.restart();
        }
    }

    Rectangle {
        anchors.fill: parent
        color: root.theme.launcherVeilColor
        opacity: root.theme.launcherVeilOpacity * root.queryPresentationProgress * root.presentationProgress

        MouseArea {
            anchors.fill: parent

            onPressed: mouse => {
                mouse.accepted = true;
                root.closeLauncher();
            }
        }
    }

    Item {
        id: launcherContent

        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 2 - root.theme.launcherInputHeight / 2 - (root.hasQuery ? root.theme.launcherInputActiveOffset : 0)

        width: root.theme.launcherWidth
        height: root.theme.launcherInputHeight + root.theme.launcherResultsTopMargin + resultsContainer.height
        opacity: root.presentationProgress
        scale: root.theme.launcherClosedScale + (1 - root.theme.launcherClosedScale) * root.presentationProgress

        Behavior on y {
            NumberAnimation {
                duration: root.theme.animationDuration
                easing.type: Easing.OutCubic
            }
        }

        Rectangle {
            id: searchBox

            anchors.top: parent.top
            width: parent.width
            height: root.theme.launcherInputHeight

            radius: root.theme.launcherInputRadius
            color: root.theme.launcherInputBg
            layer.enabled: true
            layer.effect: MultiEffect {
                autoPaddingEnabled: true
                shadowEnabled: true
                shadowColor: root.theme.launcherInputShadow
                shadowOpacity: root.theme.launcherInputShadowOpacity
                shadowBlur: root.theme.launcherInputShadowBlur
            }

            MouseArea {
                anchors.fill: parent

                onPressed: mouse => {
                    mouse.accepted = true;
                    searchInput.forceActiveFocus();
                }
            }

            Text {
                id: searchIcon

                anchors.left: parent.left
                anchors.leftMargin: root.theme.launcherInputHorizontalPadding
                anchors.verticalCenter: parent.verticalCenter

                text: ""
                color: root.theme.launcherInputFg
                font.family: root.theme.fontName
                font.pixelSize: root.theme.launcherInputFontSize
                font.weight: Font.Bold
            }

            Text {
                anchors.left: searchIcon.right
                anchors.leftMargin: root.theme.launcherResultTextSpacing
                anchors.right: parent.right
                anchors.rightMargin: root.theme.launcherInputHorizontalPadding
                anchors.verticalCenter: parent.verticalCenter

                visible: searchInput.text.length === 0
                text: "Search applications"
                color: root.theme.launcherInputPlaceholder
                elide: Text.ElideRight
                font.family: root.theme.fontName
                font.pixelSize: root.theme.launcherInputFontSize
                font.weight: Font.Bold
            }

            TextInput {
                id: searchInput

                anchors.left: searchIcon.right
                anchors.leftMargin: root.theme.launcherResultTextSpacing
                anchors.right: parent.right
                anchors.rightMargin: root.theme.launcherInputHorizontalPadding
                anchors.verticalCenter: parent.verticalCenter

                focus: root.opened
                color: root.theme.launcherInputFg
                selectionColor: root.theme.launcherResultSelectedBg
                selectedTextColor: root.theme.launcherInputFg
                clip: true

                font.family: root.theme.fontName
                font.pixelSize: root.theme.launcherInputFontSize
                font.weight: Font.Bold

                onTextChanged: {
                    root.selectedIndex = -1;
                    resultsView.positionViewAtBeginning();
                    selectionUpdateTimer.restart();
                }

                Keys.onPressed: event => {
                    switch (event.key) {
                    case Qt.Key_Escape:
                        root.closeLauncher();
                        event.accepted = true;
                        break;
                    case Qt.Key_Down:
                        root.moveSelection(1);
                        event.accepted = true;
                        break;
                    case Qt.Key_Up:
                        root.moveSelection(-1);
                        event.accepted = true;
                        break;
                    case Qt.Key_Return:
                    case Qt.Key_Enter:
                        if (root.selectedApplication)
                            root.activateApplication(root.selectedApplication);
                        event.accepted = true;
                        break;
                    }
                }
            }
        }

        Rectangle {
            id: resultsContainer

            readonly property bool hasOverflow: resultsView.contentHeight > resultsView.height + 1
            readonly property real maximumContentY: Math.max(resultsView.originY, resultsView.originY + resultsView.contentHeight - resultsView.height)
            readonly property real remainingScrollDistance: Math.max(0, resultsContainer.maximumContentY - resultsView.contentY)
            readonly property real bottomOverflowOpacity: resultsContainer.hasOverflow ? Math.min(1, resultsContainer.remainingScrollDistance / root.theme.launcherBottomShadowFadeDistance) : 0
            readonly property real scrollbarTargetReserve: root.theme.launcherScrollbarWidth + root.theme.launcherScrollbarGap
            readonly property int visibleResultCount: Math.min(root.displayedApplications.length, root.theme.launcherMaxResults)
            property real scrollbarReserve: 0

            anchors.top: searchBox.bottom
            anchors.topMargin: root.theme.launcherResultsTopMargin

            width: parent.width
            height: resultsContainer.visibleResultCount > 0 ? resultsContainer.visibleResultCount * root.theme.launcherResultHeight + (resultsContainer.visibleResultCount - 1) * root.theme.launcherResultSpacing : root.theme.launcherResultHeight
            color: "transparent"
            bottomLeftRadius: root.theme.launcherResultRadius
            bottomRightRadius: root.theme.launcherResultRadius

            visible: root.hasQuery || opacity > 0
            opacity: root.queryPresentationProgress * root.presentationProgress
            state: resultsContainer.hasOverflow ? "scrollbarShown" : "scrollbarHidden"

            onVisibleChanged: {
                if (!resultsContainer.visible && !root.hasQuery)
                    root.displayedApplications = [];
            }

            states: [
                State {
                    name: "scrollbarHidden"

                    PropertyChanges {
                        target: resultsContainer
                        scrollbarReserve: 0
                    }

                    PropertyChanges {
                        target: resultsScrollBar
                        opacity: 0
                        scale: 0.7
                    }
                },
                State {
                    name: "scrollbarShown"

                    PropertyChanges {
                        target: resultsContainer
                        scrollbarReserve: resultsContainer.scrollbarTargetReserve
                    }

                    PropertyChanges {
                        target: resultsScrollBar
                        opacity: 1
                        scale: 1
                    }
                }
            ]

            transitions: [
                Transition {
                    from: "scrollbarHidden"
                    to: "scrollbarShown"
                    reversible: true
                    enabled: resultsContainer.visible

                    SequentialAnimation {
                        NumberAnimation {
                            target: resultsContainer
                            property: "scrollbarReserve"
                            duration: root.theme.animationDuration
                            easing.type: Easing.OutCubic
                        }

                        ParallelAnimation {
                            NumberAnimation {
                                target: resultsScrollBar
                                property: "opacity"
                                duration: root.theme.animationDuration
                                easing.type: Easing.OutCubic
                            }

                            NumberAnimation {
                                target: resultsScrollBar
                                property: "scale"
                                duration: root.theme.animationDuration
                                easing.type: Easing.OutBack
                            }
                        }
                    }
                }
            ]

            transform: Translate {
                y: root.hasQuery ? 0 : -root.theme.launcherResultsRevealOffset

                Behavior on y {
                    NumberAnimation {
                        duration: root.theme.animationDuration
                        easing.type: Easing.OutCubic
                    }
                }
            }

            MouseArea {
                anchors.fill: parent

                onPressed: mouse => {
                    mouse.accepted = true;
                    searchInput.forceActiveFocus();
                }
            }

            Rectangle {
                id: resultsViewport

                anchors {
                    top: parent.top
                    right: parent.right
                    bottom: parent.bottom
                    left: parent.left
                    rightMargin: resultsContainer.scrollbarReserve
                }

                color: "transparent"
                bottomLeftRadius: root.theme.launcherResultRadius
                bottomRightRadius: root.theme.launcherResultRadius
                layer.enabled: true
                layer.effect: MultiEffect {
                    autoPaddingEnabled: false
                    maskEnabled: true
                    maskSource: ShaderEffectSource {
                        width: resultsViewport.width
                        height: resultsViewport.height

                        sourceItem: Rectangle {
                            width: resultsViewport.width
                            height: resultsViewport.height
                            color: "white"
                            bottomLeftRadius: root.theme.launcherResultRadius
                            bottomRightRadius: root.theme.launcherResultRadius
                            layer.enabled: true
                        }
                    }
                }

                ListView {
                    id: resultsView

                    anchors.fill: parent

                    visible: count > 0

                    model: root.displayedApplications
                    currentIndex: root.selectedIndex
                    spacing: root.theme.launcherResultSpacing
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds

                    ScrollBar.vertical: ScrollBar {
                        id: resultsScrollBar

                        parent: resultsContainer

                        anchors {
                            top: parent.top
                            right: parent.right
                            bottom: parent.bottom
                        }

                        active: true
                        interactive: true
                        enabled: resultsContainer.hasOverflow
                        policy: ScrollBar.AlwaysOn
                        z: 3
                        width: root.theme.launcherScrollbarWidth
                        padding: 0
                        opacity: 0
                        scale: 0.7

                        background: Item {}

                        contentItem: Rectangle {
                            implicitWidth: root.theme.launcherScrollbarWidth
                            radius: width / 2
                            color: root.theme.launcherScrollbar
                        }
                    }

                    delegate: LauncherResult {
                        id: resultRow

                        required property DesktopEntry modelData
                        required property int index

                        width: ListView.view.width
                        height: root.theme.launcherResultHeight
                        theme: root.theme
                        application: resultRow.modelData
                        selected: root.selectedIndex === resultRow.index

                        onActivated: root.activateApplication(resultRow.modelData)
                        onPointerEntered: root.selectedIndex = resultRow.index
                        onWheelScrolled: delta => root.scrollResults(delta)
                    }
                }

                Rectangle {
                    id: bottomOverflowIndicator

                    anchors {
                        right: parent.right
                        bottom: parent.bottom
                        left: parent.left
                    }

                    z: 2
                    height: root.theme.launcherBottomShadowHeight
                    color: "transparent"
                    opacity: resultsContainer.bottomOverflowOpacity

                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "transparent"
                        }

                        GradientStop {
                            position: 0.2
                            color: Qt.rgba(root.theme.launcherBottomShadowColor.r, root.theme.launcherBottomShadowColor.g, root.theme.launcherBottomShadowColor.b, root.theme.launcherBottomShadowOpacity * 0.2)
                        }

                        GradientStop {
                            position: 1
                            color: Qt.rgba(root.theme.launcherBottomShadowColor.r, root.theme.launcherBottomShadowColor.g, root.theme.launcherBottomShadowColor.b, root.theme.launcherBottomShadowOpacity)
                        }
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: root.theme.fastAnimationDuration
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }

            Rectangle {
                id: noResultsCard

                anchors {
                    top: parent.top
                    right: parent.right
                    bottom: parent.bottom
                    left: parent.left
                    rightMargin: resultsContainer.scrollbarReserve
                }

                visible: root.hasQuery && resultsView.count === 0

                radius: root.theme.launcherResultRadius
                color: root.theme.launcherResultBg
                opacity: root.theme.launcherResultOpacity
                border.width: root.theme.thinBorderWidth
                border.color: root.theme.border

                Text {
                    anchors.centerIn: parent

                    text: "No applications found"
                    color: root.theme.fg
                    font.family: root.theme.fontName
                    font.pixelSize: root.theme.titleSize
                    font.weight: Font.Bold
                }
            }
        }
    }
}
