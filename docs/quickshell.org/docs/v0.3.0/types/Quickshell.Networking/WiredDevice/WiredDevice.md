# WiredDevice

**Inherits**: `NetworkDevice`

Wired variant of a `NetworkDevice`.

## Properties

-   **linkSpeed**: `int` (readonly)
    The maximum speed of the physical device link, in megabits per second.

-   **hasLink**: `bool` (readonly)
    True if the wired device has a physical link (cable plugged in).

-   **network**: `Network` (readonly)
    The wired network for this device or `null`. This network is only available when `hasLink` is `true`.
