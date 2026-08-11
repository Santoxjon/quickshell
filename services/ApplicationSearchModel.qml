import Quickshell

import "ApplicationSearch.js" as ApplicationSearch

ScriptModel {
    id: root

    required property string searchText

    readonly property var applications: DesktopEntries.applications.values
    readonly property string query: root.searchText.trim().replace(/\s+/g, " ").toLocaleLowerCase()
    readonly property bool hasQuery: root.query.length > 0

    values: ApplicationSearch.filterApplications([...root.applications], root.query)
}
