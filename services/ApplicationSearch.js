.pragma library

function normalizeText(value) {
    return typeof value === "string" ? value.toLocaleLowerCase() : "";
}

function createSearchData(application) {
    const displayName = application.name || application.id || "Unnamed application";
    const name = normalizeText(displayName);
    const genericName = normalizeText(application.genericName);
    const keywords = application.keywords && typeof application.keywords.join === "function"
        ? normalizeText(application.keywords.join(" "))
        : "";

    return {
        application: application,
        displayName: displayName,
        name: name,
        nameWords: name.split(/\s+/),
        genericName: genericName,
        keywordWords: keywords.split(/\s+/),
        searchableText: [
            name,
            genericName,
            normalizeText(application.comment),
            normalizeText(application.id),
            keywords
        ].join(" ")
    };
}

function applicationMatches(searchData, terms) {
    return terms.every(term => searchData.searchableText.includes(term));
}

function termScore(searchData, term) {
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

function applicationScore(searchData, terms, query) {
    if (searchData.name === query)
        return 0;
    if (searchData.name.startsWith(query))
        return 1;
    if (searchData.nameWords.some(word => word.startsWith(query)))
        return 2;
    if (searchData.genericName.startsWith(query))
        return 3;

    return terms.reduce((score, term) => Math.max(score, termScore(searchData, term)), 0);
}

function filterApplications(applications, query) {
    if (!Array.isArray(applications) || typeof query !== "string" || query.length === 0)
        return [];

    const terms = query.split(" ");
    const rankedApplications = [];

    for (const application of applications) {
        if (!application)
            continue;

        const searchData = createSearchData(application);

        if (!applicationMatches(searchData, terms))
            continue;

        rankedApplications.push({
            application: searchData.application,
            name: searchData.displayName,
            score: applicationScore(searchData, terms, query)
        });
    }

    rankedApplications.sort((left, right) => {
        const scoreDifference = left.score - right.score;
        return scoreDifference !== 0 ? scoreDifference : left.name.localeCompare(right.name);
    });

    return rankedApplications.map(result => result.application);
}
