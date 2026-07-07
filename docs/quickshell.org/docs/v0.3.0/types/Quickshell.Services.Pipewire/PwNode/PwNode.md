# Quickshell.Services.Pipewire - PwNode
**Version:** v0.3.0
**Description:** A node in the pipewire connection graph.
## Properties
* `name` (string): The node’s name, corresponding to the object’s `node.name` property.
* `audio` (PwNodeAudio): Extra information present only if the node sends or receives audio.
* `isSink` (bool): If `true`, then the node accepts audio input from other nodes, if `false` the node outputs audio to other nodes.
* `properties` (unknown): The property set present on the node, as an object containing key-value pairs.
* `description` (string): The node’s description, corresponding to the object’s `node.description` property.
* `nickname` (string): The node’s nickname, corresponding to the object’s `node.nickname` property.
* `ready` (bool): True if the node is fully bound and ready to use.
* `isStream` (bool): If `true` then the node is likely to be a program, if `false` it is likely to be a hardware device.
* `id` (int): The pipewire object id of the node.
* `type` (unknown): The type of this node. Reflects Pipewire’s media.class.
