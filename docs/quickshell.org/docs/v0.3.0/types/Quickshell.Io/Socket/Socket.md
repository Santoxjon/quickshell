---
title: Socket
description: Unix socket listener.
---
# Socket
**Inherits:** [DataStream](../DataStream/DataStream.md)

Unix socket listener.

## Description

This type is used to connect to unix sockets.

## Properties
* `path`: The path to connect this socket to when `connected` is set to true.
* `connected`: Returns if the socket is currently connected.

## Functions
* `flush()`: Flush any queued writes to the socket.
* `write(data)`: Write data to the socket. Does nothing if not connected.

## Signals
* `error(error)`: This signal is sent whenever a socket error is encountered.
