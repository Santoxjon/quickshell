# BluetoothDevice
**Inherits:** `QtObject`

A tracked Bluetooth device.

## Properties
* `bonded` : `bool` (readonly) - True if pairing information is stored for future connections.
* `name` : `string` - The name of the Bluetooth device. This property may be written to create an alias, or set to an empty string to fall back to the device provided name.
* `paired` : `bool` (readonly) - True if the device is paired to the computer.
* `batteryAvailable` : `bool` (readonly) - True if the connected device reports its battery level.
* `battery` : `real` (readonly) - Battery level of the connected device, from `0.0` to `1.0`. Only valid if `batteryAvailable` is true.
* `deviceName` : `string` (readonly) - The name of the Bluetooth device, ignoring user provided aliases.
* `address` : `string` (readonly) - MAC address of the device.
* `trusted` : `bool` - True if the device is considered to be trusted by the system.
* `connected` : `bool` - True if the device is currently connected to the computer.
* `icon` : `string` (readonly) - System icon representing the device type.
* `wakeAllowed` : `bool` - True if the device is allowed to wake up the host system from suspend.
* `adapter` : `BluetoothAdapter` (readonly) - The Bluetooth adapter this device belongs to.
* `pairing` : `bool` (readonly) - True if the device is currently being paired.
* `state` : `BluetoothDeviceState` (readonly) - Connection state of the device.
* `blocked` : `bool` - True if the device is blocked from connecting.
* `dbusPath` : `string` (readonly) - DBus path of the device under the `org.bluez` system service.

## Functions
* `cancelPair()` : `void` - Cancel an active pairing attempt.
* `connect()` : `void` - Attempt to connect to the device.
* `disconnect()` : `void` - Disconnect from the device.
* `forget()` : `void` - Forget the device.
* `pair()` : `void` - Attempt to pair the device.
