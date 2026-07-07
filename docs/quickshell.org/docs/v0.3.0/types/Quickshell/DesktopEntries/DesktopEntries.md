# DesktopEntries

**Inherits**: `QtObject`

Desktop entry index.

Primarily useful for looking up icons and metadata from an id, as there is currently no mechanism for usage based sorting of entries and other launcher niceties.

## Properties

- `applications`: `ObjectModel<DesktopEntry>` (readonly) - All desktop entries of type Application that are not Hidden or NoDisplay.

## Functions

- `byId(id: string)`: `DesktopEntry` - Look up a desktop entry by name. Includes NoDisplay entries. May return null.
- `heuristicLookup(name: string)`: `DesktopEntry` - Look up a desktop entry by name using heuristics. Unlike `byId()`, if no exact matches are found this function will try to guess - potentially incorrectly. May return null.

## Signals

- `applicationsChanged()`
