import Quickshell

ScriptModel {
    id: root

    required property string searchText

    readonly property var applications: DesktopEntries.applications.values
    readonly property string query: root.searchText.trim().replace(/\s+/g, " ").toLocaleLowerCase()
    readonly property bool hasQuery: root.query.length > 0

    values: root.filteredApplications()

    function normalizeText(value: var): string {
        return typeof value === "string" ? value.toLocaleLowerCase() : "";
    }

    function createSearchData(application: DesktopEntry): var {
        const displayName = application.name || application.id || "Unnamed application";
        const name = root.normalizeText(displayName);
        const genericName = root.normalizeText(application.genericName);
        const keywords = application.keywords ? root.normalizeText(application.keywords.join(" ")) : "";

        return {
            "application": application,
            "displayName": displayName,
            "name": name,
            "nameWords": name.split(/\s+/),
            "genericName": genericName,
            "keywordWords": keywords.split(/\s+/),
            "searchableText": [name, genericName, root.normalizeText(application.comment), root.normalizeText(application.id), keywords].join(" ")
        };
    }

    function applicationMatches(searchData: var, terms: list<string>): bool {
        return terms.every(term => searchData.searchableText.includes(term));
    }

    function termScore(searchData: var, term: string): int {
        if (searchData.nameWords.some(word => word.startsWith(term)))
            return 2;
        if (searchData.genericName.startsWith(term))
            return 3;
        if (searchData.keywordWords.some(word => word.startsWith(term)))
            return 4;
        if (searchData.name.includes(term))
            return 5;

        return 6;
    }

    function applicationScore(searchData: var, terms: list<string>, query: string): int {
        if (searchData.name === query)
            return 0;
        if (searchData.name.startsWith(query))
            return 1;
        if (searchData.nameWords.some(word => word.startsWith(query)))
            return 2;
        if (searchData.genericName.startsWith(query))
            return 3;

        return terms.reduce((score, term) => Math.max(score, root.termScore(searchData, term)), 0);
    }

    function filteredApplications(): var {
        if (!root.hasQuery)
            return [];

        const terms = root.query.split(" ");
        const rankedApplications = [];

        for (const application of root.applications) {
            const searchData = root.createSearchData(application);

            if (!root.applicationMatches(searchData, terms))
                continue;

            rankedApplications.push({
                "application": searchData.application,
                "name": searchData.displayName,
                "score": root.applicationScore(searchData, terms, root.query)
            });
        }

        rankedApplications.sort((left, right) => {
            const scoreDifference = left.score - right.score;

            return scoreDifference !== 0 ? scoreDifference : left.name.localeCompare(right.name);
        });

        return rankedApplications.map(result => result.application);
    }
}
