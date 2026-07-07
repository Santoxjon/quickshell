# ExclusionMode

**Inherits**: `QtObject`

Panel exclusion mode. See also `PanelWindow.exclusionMode`.

## Enumerations

### ExclusionMode
- **Auto**: Decide the exclusion zone based on the window dimensions and anchors. Will attempt to reserve exactly enough space for the window and its margins if exactly 3 anchors are connected.
- **Normal**: Respect the exclusion zone of other shell layers and optionally set one.
- **Ignore**: Ignore exclusion zones of other shell layers. You cannot set an exclusion zone in this mode.
