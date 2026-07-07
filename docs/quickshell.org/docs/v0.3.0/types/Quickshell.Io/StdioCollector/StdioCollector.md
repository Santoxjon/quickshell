---
title: StdioCollector
description: DataStreamParser that collects all output into a buffer
---
# StdioCollector
**Inherits:** [DataStreamParser](../DataStreamParser/DataStreamParser.md)

DataStreamParser that collects all output into a buffer.

This is useful for commands that do not produce continuous output, but rather just spit out a blob of text and exit.
The output is available as either `text` or `data`.

## Properties
| Type | Name | Description |
| --- | --- | --- |
| string | text | The stdio buffer exposed as text. if `waitForEnd` is true, this will not change until the stream ends. |
| unknown | data | The stdio buffer exposed as an [ArrayBuffer](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer). if `waitForEnd` is true, this will not change until the stream ends. |
| bool | waitForEnd | If true, `text` and `data` will not be updated until the stream ends. Defaults to true. |

## Signals
| Name | Description |
| --- | --- |
| streamFinished() | Emitted when the stream has finished. |
