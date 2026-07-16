import QtQml

LineProcess {
    id: root

    signal jsonReceived(var value)

    function parseLine(line: string): void {
        try {
            root.jsonReceived(JSON.parse(line));
        } catch (error) {
            console.warn(`${root.logName}: invalid JSON output: ${error}`);
        }
    }

    onLineReceived: line => root.parseLine(line)
}
