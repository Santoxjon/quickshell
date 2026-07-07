# Quickshell.Services.Pipewire - PwNodeAudio
**Version:** v0.3.0
**Description:** Audio specific properties of pipewire nodes.
## Properties
* `muted` (bool): If the node is currently muted. Setting this property changes the mute state.
* `volume` (real): The average volume over all channels of the node. Setting this property modifies the volume of all channels proportionately.
* `volumes` (list<real>): The volumes of each audio channel individually.
* `channels` (list<PwAudioChannel>): The audio channels present on the node.
