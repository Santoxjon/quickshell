# Networking

The Network service. This is a singleton type, which can be used to view, configure, and connect to various networks.

## Properties

-   **wifiEnabled**: `bool`
    Switch for the rfkill software block of all wireless devices.

-   **wifiHardwareEnabled**: `bool` (readonly)
    State of the rfkill hardware block of all wireless devices.

-   **backend**: `NetworkBackendType` (readonly)
    The backend being used to power the Network service.

-   **connectivity**: `NetworkConnectivity` (readonly)
    The result of the last connectivity check.

-   **canCheckConnectivity**: `bool` (readonly)
    True if the backend supports connectivity checks.

-   **connectivityCheckEnabled**: `bool`
    True if connectivity checking is enabled.

-   **devices**: `ObjectModel<NetworkDevice>` (readonly)
    A list of all network devices. Networks are exposed through their respective devices.

## Functions

-   **checkConnectivity()**: `void`
    Re-check the network connectivity state immediately.
