import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Widgets

PanelWindow {
    id: root

    required property var theme

    property bool opened: false
    property int selectedIndex: -1
    property var pendingApplication: null
    property real presentationProgress: root.opened ? 1 : 0

    readonly property string query: searchInput.text.trim().toLocaleLowerCase()
    readonly property bool hasQuery: root.query.length > 0

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
        if (!root.opened && root.presentationProgress === 0) {
            const application = root.pendingApplication;
            root.pendingApplication = null;
            searchInput.clear();
            root.selectedIndex = -1;

            if (application)
                application.execute();
        }
    }

    function focusedScreen(): var {
        const focusedMonitor = Hyprland.focusedMonitor;

        if (!focusedMonitor)
            return root.screen;

        for (let index = 0; index < Quickshell.screens.length; index++) {
            const candidate = Quickshell.screens[index];
            const monitor = Hyprland.monitorFor(candidate);

            if (monitor && monitor.name === focusedMonitor.name)
                return candidate;
        }

        return root.screen;
    }

    function openLauncher(): void {
        if (root.opened) {
            searchInput.forceActiveFocus();
            return;
        }

        root.pendingApplication = null;

        const targetScreen = root.focusedScreen();

        if (targetScreen)
            root.screen = targetScreen;

        searchInput.clear();
        root.selectedIndex = -1;
        root.opened = true;
        Qt.callLater(() => searchInput.forceActiveFocus());
    }

    function closeLauncher(): void {
        if (!root.opened)
            return;

        root.opened = false;
    }

    function applicationText(application): string {
        const keywords = application.keywords ? application.keywords.join(" ") : "";

        return [
            application.name || "",
            application.genericName || "",
            application.comment || "",
            application.id || "",
            keywords
        ].join(" ").toLocaleLowerCase();
    }

    function applicationMatches(application, searchText: string): bool {
        const searchableText = root.applicationText(application);
        const terms = searchText.split(/\s+/);

        return terms.every(term => searchableText.includes(term));
    }

    function applicationScore(application, searchText: string): int {
        const name = (application.name || "").toLocaleLowerCase();
        const genericName = (application.genericName || "").toLocaleLowerCase();
        const keywords = application.keywords ? application.keywords.join(" ").toLocaleLowerCase() : "";

        if (name === searchText)
            return 0;
        if (name.startsWith(searchText))
            return 1;
        if (name.split(/\s+/).some(word => word.startsWith(searchText)))
            return 2;
        if (genericName.startsWith(searchText))
            return 3;
        if (keywords.split(/\s+/).some(word => word.startsWith(searchText)))
            return 4;
        if (name.includes(searchText))
            return 5;

        return 6;
    }

    function filteredApplications(): var {
        if (!root.hasQuery)
            return [];

        const applications = DesktopEntries.applications.values.filter(application => root.applicationMatches(application, root.query));

        return [...applications].sort((left, right) => {
            const scoreDifference = root.applicationScore(left, root.query) - root.applicationScore(right, root.query);

            if (scoreDifference !== 0)
                return scoreDifference;

            return left.name.localeCompare(right.name);
        });
    }

    function moveSelection(direction: int): void {
        const resultCount = resultsView.count;

        if (resultCount === 0)
            return;

        if (root.selectedIndex < 0)
            root.selectedIndex = direction > 0 ? 0 : resultCount - 1;
        else
            root.selectedIndex = (root.selectedIndex + direction + resultCount) % resultCount;

        resultsView.positionViewAtIndex(root.selectedIndex, ListView.Contain);
    }

    function selectFirstResult(): void {
        root.selectedIndex = root.hasQuery && applicationsModel.values.length > 0 ? 0 : -1;

        if (root.selectedIndex === 0)
            resultsView.positionViewAtBeginning();
    }

    function scrollResults(wheelDelta: real): void {
        if (wheelDelta === 0)
            return;

        const minimumY = resultsView.originY;
        const maximumY = Math.max(minimumY, minimumY + resultsView.contentHeight - resultsView.height);
        const targetY = resultsView.contentY - Math.sign(wheelDelta) * root.theme.launcherScrollStep;

        resultsView.cancelFlick();
        resultsView.contentY = Math.max(minimumY, Math.min(maximumY, targetY));
    }

    function activateApplication(application): void {
        if (!root.opened || !application)
            return;

        root.pendingApplication = application;
        root.closeLauncher();
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

    ScriptModel {
        id: applicationsModel

        values: root.filteredApplications()

        onValuesChanged: Qt.callLater(() => root.selectFirstResult())
    }

    Rectangle {
        anchors.fill: parent
        color: root.theme.launcherVeilColor
        opacity: root.hasQuery ? root.theme.launcherVeilOpacity * root.presentationProgress : 0

        Behavior on opacity {
            NumberAnimation {
                duration: root.opened ? root.theme.animationDuration : root.theme.fastAnimationDuration
                easing.type: Easing.OutCubic
            }
        }

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

        MultiEffect {
            anchors.fill: searchBox
            source: searchBox
            autoPaddingEnabled: true
            shadowEnabled: true
            shadowColor: root.theme.launcherInputShadow
            shadowOpacity: root.theme.launcherInputShadowOpacity
            shadowBlur: root.theme.launcherInputShadowBlur
            shadowVerticalOffset: root.theme.launcherInputShadowOffset
        }

        Rectangle {
            id: searchBox

            anchors.top: parent.top
            width: parent.width
            height: root.theme.launcherInputHeight

            radius: root.theme.launcherInputRadius
            color: root.theme.launcherInputBg

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
                    Qt.callLater(() => root.selectFirstResult());
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
                        if (root.selectedIndex >= 0)
                            root.activateApplication(applicationsModel.values[root.selectedIndex]);
                        event.accepted = true;
                        break;
                    }
                }
            }
        }

        Item {
            id: resultsContainer

            anchors.top: searchBox.bottom
            anchors.topMargin: root.theme.launcherResultsTopMargin

            width: parent.width
            height: applicationsModel.values.length > 0
                ? Math.min(applicationsModel.values.length, root.theme.launcherMaxResults) * root.theme.launcherResultHeight
                    + (Math.min(applicationsModel.values.length, root.theme.launcherMaxResults) - 1) * root.theme.launcherResultSpacing
                : root.theme.launcherResultHeight

            visible: root.hasQuery || opacity > 0
            opacity: root.hasQuery ? root.presentationProgress : 0

            transform: Translate {
                y: root.hasQuery ? 0 : -root.theme.launcherResultsRevealOffset

                Behavior on y {
                    NumberAnimation {
                        duration: root.theme.animationDuration
                        easing.type: Easing.OutCubic
                    }
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: root.opened ? root.theme.animationDuration : root.theme.fastAnimationDuration
                    easing.type: Easing.OutCubic
                }
            }

            MouseArea {
                anchors.fill: parent

                onPressed: mouse => {
                    mouse.accepted = true;
                    searchInput.forceActiveFocus();
                }
            }

            ListView {
                id: resultsView

                anchors {
                    top: parent.top
                    right: parent.right
                    bottom: parent.bottom
                    left: parent.left
                    rightMargin: root.theme.launcherScrollbarWidth + root.theme.launcherScrollbarGap
                }

                visible: count > 0

                model: applicationsModel
                currentIndex: root.selectedIndex
                spacing: root.theme.launcherResultSpacing
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                ScrollBar.vertical: ScrollBar {
                    parent: resultsContainer

                    anchors {
                        top: parent.top
                        right: parent.right
                        bottom: parent.bottom
                    }

                    active: true
                    interactive: true
                    policy: resultsView.contentHeight > resultsView.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
                    width: root.theme.launcherScrollbarWidth
                    padding: 0

                    background: Item {}

                    contentItem: Rectangle {
                        implicitWidth: root.theme.launcherScrollbarWidth
                        radius: width / 2
                        color: root.theme.launcherScrollbar
                    }
                }

                delegate: Rectangle {
                    id: resultRow

                    required property var modelData
                    required property int index

                    readonly property bool selected: root.selectedIndex === resultRow.index
                    readonly property bool hovered: resultMouseArea.containsMouse

                    width: ListView.view.width
                    height: root.theme.launcherResultHeight

                    radius: root.theme.launcherResultRadius
                    color: resultRow.selected ? root.theme.launcherResultSelectedBg : root.theme.launcherResultBg
                    opacity: resultRow.hovered || resultRow.selected ? 1 : root.theme.launcherResultOpacity
                    border.width: root.theme.thinBorderWidth
                    border.color: root.theme.border

                    Behavior on color {
                        ColorAnimation {
                            duration: root.theme.fastAnimationDuration
                        }
                    }

                    Behavior on opacity {
                        NumberAnimation {
                            duration: root.theme.fastAnimationDuration
                            easing.type: Easing.OutCubic
                        }
                    }

                    IconImage {
                        id: applicationIcon

                        anchors.left: parent.left
                        anchors.leftMargin: root.theme.launcherResultHorizontalPadding
                        anchors.verticalCenter: parent.verticalCenter

                        width: root.theme.launcherResultIconSize
                        height: width

                        source: Quickshell.iconPath(resultRow.modelData.icon, true)
                        asynchronous: true
                        mipmap: true
                    }

                    Text {
                        anchors.centerIn: applicationIcon
                        visible: applicationIcon.status === Image.Error || applicationIcon.status === Image.Null

                        text: ""
                        color: root.theme.fg
                        font.family: root.theme.fontName
                        font.pixelSize: root.theme.launcherResultIconSize - 8
                    }

                    Column {
                        anchors.left: applicationIcon.right
                        anchors.leftMargin: root.theme.launcherResultTextSpacing
                        anchors.right: parent.right
                        anchors.rightMargin: root.theme.launcherResultHorizontalPadding
                        anchors.verticalCenter: parent.verticalCenter

                        spacing: 1

                        Text {
                            width: parent.width

                            text: resultRow.modelData.name
                            color: root.theme.fg
                            elide: Text.ElideRight
                            font.family: root.theme.fontName
                            font.pixelSize: root.theme.titleSize
                            font.weight: Font.Bold
                        }

                        Text {
                            width: parent.width

                            visible: text.length > 0
                            text: resultRow.modelData.genericName || resultRow.modelData.comment || ""
                            color: root.theme.palette3
                            elide: Text.ElideRight
                            font.family: root.theme.fontName
                            font.pixelSize: root.theme.captionFontSize
                        }
                    }

                    MouseArea {
                        id: resultMouseArea

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: root.activateApplication(resultRow.modelData)
                        onEntered: root.selectedIndex = resultRow.index

                        onWheel: wheel => {
                            const wheelDelta = wheel.angleDelta.y !== 0 ? wheel.angleDelta.y : wheel.pixelDelta.y;

                            root.scrollResults(wheelDelta);
                            wheel.accepted = true;
                        }
                    }
                }
            }

            Rectangle {
                anchors.fill: parent
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
