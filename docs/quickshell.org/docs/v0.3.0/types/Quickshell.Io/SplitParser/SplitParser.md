---
title: SplitParser
description: DataStreamParser for delimited data streams.
---
# SplitParser
**Inherits:** [DataStreamParser](../DataStreamParser/DataStreamParser.md)

DataStreamParser for delimited data streams.

## Description

This type is used to parse delimited data streams. `DataStreamParser.read()` is emitted once per delimited chunk of the stream.

## Properties
* `splitMarker`: The delimiter for parsed data. May be multiple characters. Defaults to `\n`. If the delimiter is empty read lengths may be arbitrary (whatever is returned by the underlying read call.)
