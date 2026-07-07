# Quickshell.Services.Pipewire - PwNodePeakMonitor
**Version:** v0.3.0
**Description:** Monitors peak levels of an audio node.
## Properties
* `node` (PwNode): The node to monitor. Must be an audio node.
* `channels` (list<PwAudioChannel>): Channel positions for the captured format. Length matches `peaks`.
* `enabled` (bool): If true, the monitor is actively capturing and computing peaks. Defaults to true.
* `peak` (real): Maximum value of `peaks`.
* `peaks` (list<real>): Per-channel peak noise levels (0.0-1.0). Length matches `channels`. The channel’s volume does not affect this property.
