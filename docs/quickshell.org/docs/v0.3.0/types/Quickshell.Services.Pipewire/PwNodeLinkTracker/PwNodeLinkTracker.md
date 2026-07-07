# PwNodeLinkTracker
**Description:** Tracks non-monitor link connections to a given node.

## Properties
*   `node` : PwNode
    *   **Description:** The node to track connections to.
*   `linkGroups` : list<PwLinkGroup>
    *   **Description:** Link groups connected to the given node, excluding monitors.
    *   If the node is a sink, links which target the node will be tracked.
    *   If the node is a source, links which source the node will be tracked.

## Functions
*This type has no functions.*
