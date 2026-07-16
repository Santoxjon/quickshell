import Quickshell.Io

Process {
    id: root

    required property string logName

    signal jsonReceived(var value)

    function parseLine(line: string): void {
        try {
            root.jsonReceived(JSON.parse(line));
        } catch (error) {
            console.warn(`${root.logName}: invalid JSON output: ${error}`);
        }
    }

    stdout: SplitParser {
        onRead: line => root.parseLine(line)
    }

    stderr: SplitParser {
        onRead: line => console.warn(`${root.logName}: ${line}`)
    }
}
