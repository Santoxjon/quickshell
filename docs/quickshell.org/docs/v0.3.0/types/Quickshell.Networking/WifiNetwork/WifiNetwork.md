# WifiNetwork

**Inherits**: `Network`

WiFi subtype of `Network`.

## Properties

-   **signalStrength**: `real` (readonly)
    The current signal strength of the network, from 0.0 to 1.0.

-   **security**: `WifiSecurityType` (readonly)
    The security type of the wifi network.

## Functions

-   **connectWithPsk**: `void` connectWithPsk(psk)
    Attempt to connect to the network with the given PSK. If the PSK is wrong, a `Network.connectionFailed()` signal will be emitted with `NoSecrets`.
    The networking backend may store the PSK for future use with `Network.connect()`. As such, calling that function first is recommended to avoid having to show a prompt if not required.
    PSKs should only be provided when the `security` is one of `WpaPsk`, `Wpa2Psk`, or `Sae`.
