---
title: ConnectionFailReason
description: The reason a connection failed.
---
# ConnectionFailReason
The reason a connection failed.

## Functions
| Type | Name | Description |
| --- | --- | --- |
| string | toString(reason) | Converts a `ConnectionFailReason` to a string. |

## Variants
| Name | Description |
| --- | --- |
| NoSecrets | Secrets were required, but not provided. |
| WifiClientFailed | The Wi-Fi supplicant failed. |
| Unknown | An unknown error occurred. |
