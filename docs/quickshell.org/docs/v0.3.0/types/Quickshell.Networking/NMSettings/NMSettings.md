---
title: NMSettings
description: A NetworkManager connection settings profile.
---
# NMSettings
A NetworkManager connection settings profile.

## Properties
| Type | Name | Description |
| --- | --- | --- |
| string | uuid | A universally unique identifier for the connection. |
| string | id | The human-readable unique identifier for the connection. |

## Functions
| Type | Name | Description |
| --- | --- | --- |
| void | clearSecrets() | Clear all of the secrets belonging to the settings. |
| void | forget() | Delete the settings. |
| unknown | read() | Get the settings map describing this network configuration. |
| void | write(settings) | Update the connection with new settings and save the connection to disk. |

## Signals
| Name | Description |
| --- | --- |
| loaded() | Emitted when the settings have been loaded. |
| settingsChanged(settings) | Emitted when the settings have been changed. |
