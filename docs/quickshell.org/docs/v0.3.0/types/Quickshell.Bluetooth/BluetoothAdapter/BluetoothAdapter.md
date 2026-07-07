# BluetoothAdapter
**Inherits:** [QObject](https://doc.qt.io/qt-6/qobject.html)

A Bluetooth adapter.

## Properties
* `dbusPath` : `string` (readonly) - DBus path of the adapter under the `org.bluez` system service.
* `discoverableTimeout` : `int` - Timeout in seconds for how long the adapter stays discoverable after `discoverable` is set to true. A value of 0 means the adapter stays discoverable forever.
* `pairable` : `bool` - True if the adapter is accepting incoming pairing requests. This only affects incoming pairing requests and should typically only be changed by system settings applications. Defaults to true.
* `discoverable` : `bool` - True if the adapter can be discovered by other bluetooth devices.
* `enabled` : `bool` - True if the adapter is currently enabled. More detailed state is available from `state`.
* `pairableTimeout` : `int` - Timeout in seconds for how long the adapter stays pairable after `pairable` is set to true. A value of 0 means the adapter stays pairable forever. Defaults to 0.
* `devices` : `ObjectModel<BluetoothDevice>` (readonly) - Bluetooth devices connected to this adapter.
* `adapterId` : `string` (readonly) - The internal ID of the adapter (e.g., “hci0”).
* `state` : `BluetoothAdapterState` (readonly) - Detailed power state of the adapter.
* `name` : `string` (readonly) - System provided name of the adapter. See `adapterId` for the internal identifier.
* `discovering` : `bool` - True if the adapter is scanning for new devices.
