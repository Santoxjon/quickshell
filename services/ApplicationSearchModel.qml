import Quickshell

ScriptModel {
    id: root

    required property string searchText

    readonly property var applications: DesktopEntries.applications.values
    readonly property string query: root.searchText.trim().replace(/\s+/g, " ").toLocaleLowerCase()
    readonly property bool hasQuery: root.query.length > 0

    values: root.filteredApplications()

    function createSearchData(application: DesktopEntry): var {
        const name = application.name.toLocaleLowerCase();
        const genericName = application.genericName.toLocaleLowerCase();
        const keywords = application.keywords.join(" ").toLocaleLowerCase();

        return {
            "application": application,
            "displayName": application.name,
            "name": name,
            "nameWords": name.split(/\s+/),
            "genericName": genericName,
            "keywordWords": keywords.split(/\s+/),
            "searchableText": [name, genericName, application.comment.toLocaleLowerCase(), application.id.toLocaleLowerCase(), keywords].join(" ")
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

    function applicationScore(searchData: var, terms: list<string>): int {
        if (searchData.name === root.query)
            return 0;
        if (searchData.name.startsWith(root.query))
            return 1;
        if (searchData.nameWords.some(word => word.startsWith(root.query)))
            return 2;
        if (searchData.genericName.startsWith(root.query))
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
                "score": root.applicationScore(searchData, terms)
            });
        }

        rankedApplications.sort((left, right) => {
            const scoreDifference = left.score - right.score;

            return scoreDifference !== 0 ? scoreDifference : left.name.localeCompare(right.name);
        });

        return rankedApplications.map(result => result.application);
    }
}
