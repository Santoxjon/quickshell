# Pipewire

**Version:** v0.3.0

**Description:**
Contains links to all pipewire objects.

## Properties

*   `ready`: `bool` (readonly) - This property is true if quickshell has completed its initial sync with the pipewire server. If true, nodes, links and sync/source preferences will be in a good state.
*   `links`: `ObjectModel<PwLink>` (readonly) - All links present in pipewire.
*   `linkGroups`: `ObjectModel<PwLinkGroup>` (readonly) - All link groups present in pipewire.
*   `defaultAudioSink`: `PwNode` (readonly) - The default audio sink (output) or `null`.
*   `nodes`: `ObjectModel<PwNode>` (readonly) - All nodes present in pipewire.
*   `preferredDefaultAudioSource`: `PwNode` - The preferred default audio source (input) or `null`.
*   `defaultAudioSource`: `PwNode` (readonly) - The default audio source (input) or `null`.
*   `preferredDefaultAudioSink`: `PwNode` - The preferred default audio sink (output) or `null`.
