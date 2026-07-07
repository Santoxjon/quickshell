# NetworkConnectivity

The degree to which the host can reach the internet.

## Functions

-   **toString(conn)**: `string`

## Variants

-   **Unknown**
    Network connectivity is unknown. This means the connectivity checks are disabled or have not run yet.

-   **Portal**
    The internet connection is hijacked by a captive portal gateway.
    This indicates the shell should open a sandboxed web browser window for the purpose of authenticating to a gateway.

-   **Limited**
    The host is connected to a network but does not appear to be able to reach the full internet.

-   **None**
    The host is not connected to any network.

-   **Full**
    The host is connected to a network and appears to be able to reach the full internet.
