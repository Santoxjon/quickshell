---
title: Network
description: A network.
---
# Network
A network.

## Properties
| Type | Name | Description |
| --- | --- | --- |
| list<NMSettings> | nmSettings | A list of NetworkManager connection settings profiles for this network. |
| ConnectionState | state | The connectivity state of the network. |
| bool | stateChanging | If the network is currently connecting or disconnecting. |
| NetworkDevice | device | The device this network belongs to. |
| bool | known | True if the wifi network has known connection settings saved. |
| string | name | The name of the network. |
| bool | connected | True if the network is connected. |

## Functions
| Type | Name | Description |
| --- | --- | --- |
| void | connect() | Attempt to connect to the network. |
| void | connectWithSettings(settings) | Attempt to connect to the network with a specific nmSettings entry. |
| void | disconnect() | Disconnect from the network. |
| void | forget() | Forget all connection settings for this network. |

## Signals
| Name | Description |
| --- | --- |
| connectionFailed(reason) | Signals that a connection to the network has failed because of the given ConnectionFailReason. |
