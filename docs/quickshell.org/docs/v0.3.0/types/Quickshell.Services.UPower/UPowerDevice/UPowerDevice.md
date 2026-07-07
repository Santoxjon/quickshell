# Quickshell.Services.UPower - UPowerDevice
**Version:** v0.3.0
**Description:** A device exposed through the UPower system service.
## Properties
* `type`: `DeviceType` - The type of device.
* `energy`: `real` - Current energy level of the device in watt-hours.
* `isPresent`: `bool` - If the power source is present in the bay or slot, useful for hot-removable batteries.
* `timeToEmpty`: `real` - Estimated time until the device is fully discharged, in seconds.
* `model`: `string` - Model name of the device.
* `energyCapacity`: `real` - Maximum energy capacity of the device in watt-hours
* `powerSupply`: `bool` - If the device is a power supply for your computer and can provide charge.
* `healthPercentage`: `real` - Health of the device as a percentage of its original health.
* `ready`: `bool` - If device statistics have been queried for this device yet.
* `healthSupported`: `bool` - No details provided
* `iconName`: `string` - Name of the icon representing the current state of the device, or an empty string if not provided.
* `isLaptopBattery`: `bool` - If the device is a laptop battery or not.
* `changeRate`: `real` - Rate of energy change in watts (positive when charging, negative when discharging).
* `nativePath`: `string` - Native path of the device specific to your OS.
* `timeToFull`: `real` - Estimated time until the device is fully charged, in seconds.
* `state`: `UPowerDeviceState` - Current state of the device.
* `percentage`: `real` - Current charge level as a percentage.
