# NetworkDevice

A network device.

## Properties

-   **autoconnect**: `bool`
    True if the device is allowed to autoconnect to a network.

-   **address**: `string` (readonly)
    The hardware address of the device in the XX:XX:XX:XX:XX:XX format.

-   **connected**: `bool` (readonly)
    True if the device is connected.

-   **name**: `string` (readonly)
    The name of the device’s control interface.

-   **networks**: `ObjectModel<Network>` (readonly)
    A list of available or connected networks for this device.

-   **type**: `DeviceType` (readonly)
    The device type.

-   **state**: `ConnectionState` (readonly)
    Connection state of the device.

## Functions

-   **disconnect()**: `void`
    Disconnects the device and prevents it from automatically activating further connections.
