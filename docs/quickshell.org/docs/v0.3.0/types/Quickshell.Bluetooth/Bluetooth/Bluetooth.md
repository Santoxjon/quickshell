# Bluetooth
**Inherits:** [QObject](https://doc.qt.io/qt-6/qobject.html)

Bluetooth manager.

## Properties
* `defaultAdapter` : `BluetoothAdapter` (readonly) - The default bluetooth adapter. Usually there is only one.
* `adapters` : `ObjectModel<BluetoothAdapter>` (readonly) - A list of all bluetooth adapters. See `defaultAdapter` for the default.
* `devices` : `ObjectModel<BluetoothDevice>` (readonly) - A list of all connected bluetooth devices across all adapters. See `BluetoothAdapter.devices` for the devices connected to a single adapter.
