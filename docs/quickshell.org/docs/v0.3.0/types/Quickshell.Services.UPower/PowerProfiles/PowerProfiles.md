# Quickshell.Services.UPower - PowerProfiles
**Version:** v0.3.0
**Description:** Provides access to the Power Profiles service.
## Properties
* `hasPerformanceProfile`: `bool` - If the system has a performance profile.
* `profile`: `PowerProfile` - The current power profile.
* `holds`: `list` - Power profile holds created by other applications.
* `degradationReason`: `PerformanceDegradationReason` - If power-profiles-daemon detects degraded system performance, the reason for the degradation will be present here.
