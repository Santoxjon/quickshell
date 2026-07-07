
# PwLink

**Version:** v0.3.0

**Description:**
A connection between pipewire nodes.

## Properties

* `state` (PwLinkState): The current state of the link.
* `target` (PwNode): The node that is *receiving* information. (the sink)
* `id` (int): The pipewire object id of the link.
* `source` (PwNode): The node that is *sending* information. (the source)
