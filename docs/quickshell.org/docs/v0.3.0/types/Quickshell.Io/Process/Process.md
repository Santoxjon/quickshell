---
title: Process
description: Child process.
---
# Process
**Inherits:** [QObject](https://doc.qt.io/qt-6/qobject.html)

Child process.

## Description

The Process type allows you to launch and interact with child processes.

## Example

```qml
import Quickshell.Io 1.0

Process {
  running: true
  command: [ "some-command", "arg" ]
  stdout: StdioCollector {
    onStreamFinished: console.log(`line read: ${this.text}`)
  }
}
```

## Properties
* `stdout`: The parser for stdout. If the parser is null the process’s stdout channel will be closed and no further data will be read, even if a new parser is attached.
* `workingDirectory`: The working directory of the process. Defaults to quickshell’s working directory.
* `clearEnvironment`: If the process’s environment should be cleared prior to applying environment. Defaults to false.
* `stdinEnabled`: If stdin is enabled. Defaults to false. If this property is false the process’s stdin channel will be closed and write() will do nothing, even if set back to true.
* `command`: The command to execute. Each argument is its own string, which means you don’t have to deal with quoting anything.
* `environment`: Environment of the executed process.
* `processId`: The process ID of the running process or `null` if running is false.
* `stderr`: The parser for stderr. If the parser is null the process’s stdout channel will be closed and no further data will be read, even if a new parser is attached.
* `running`: If the process is currently running. Defaults to false.

## Functions
* `exec(context)`: Launch a process with the given arguments, stopping any currently running process.
* `signal(signal)`: Sends a signal to the process if running is true, otherwise does nothing.
* `startDetached()`: Launches an instance of the process detached from Quickshell.
* `write(data)`: Writes to the process’s stdin. Does nothing if running is false.

## Signals
* `started()`: Emitted when the process starts.
* `exited(exitCode, exitStatus)`: Emitted when the process exits.
