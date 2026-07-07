# Quickshell.Services.UPower - PerformanceDegradationReason
**Version:** v0.3.0
**Description:** Reason for performance degradation exposed by the PowerProfiles service.
## Functions
* `toString(reason)`: `string`
## Variants
* `HighTemperature` - Performance has been reduced due to high system temperatures.
* `LapDetected` - Performance has been reduced due to the computer’s lap detection function, which attempts to keep the computer from getting too hot while on your lap.
* `None` - Performance has not been degraded in a way power-profiles-daemon can detect.
