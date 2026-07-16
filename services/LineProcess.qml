import Quickshell.Io

Process {
    id: root

    required property string logName

    signal lineReceived(string line)

    stdout: SplitParser {
        onRead: line => root.lineReceived(line)
    }

    stderr: SplitParser {
        onRead: line => console.warn(`${root.logName}: ${line}`)
    }
}
