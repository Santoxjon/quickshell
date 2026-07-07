---
title: SocketServer
description: Unix socket server.
---
# SocketServer
**Inherits:** [QObject](https://doc.qt.io/qt-6/qobject.html)

Unix socket server.

## Description

This type is used to create unix socket servers.

## Example

```qml
SocketServer {
  active: true
  path: "/path/too/socket.sock"
  handler: Socket {
    onConnectedChanged: {
      console.log(connected ? "new connection!" : "connection dropped!")
    }
    parser: SplitParser {
      onRead: message => console.log(`read message from socket: ${message}`)
    }
  }
}
```

## Properties
* `path`: The path to create the socket server at. Setting this property while the server is active will have no effect.
* `handler`: Connection handler component. Must create a `Socket`. The created socket should not set `connected` or `path` or the incoming socket connection will be dropped (they will be set by the socket server.) Setting `connected` to false on the created socket after connection will close and delete it.
* `active`: If the socket server is currently active. Defaults to false. Setting this to false will destroy all active connections and delete the socket file on disk. If path is empty setting this property will have no effect.
