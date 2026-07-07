# WindowManager
**Version:** v0.3.0
**Description:** Window management interfaces exposed by the window manager.

## Properties
- `windowsetProjections`: `list<WindowsetProjection>` (readonly) - All windowset projections tracked by the WM. Does not include internal projections from `screenProjection()`.
- `windowsets`: `list<Windowset>` (readonly) - All windowsets tracked by the WM across all projections.

## Functions
- `screenProjection(screen)`: `ScreenProjection` - Returns an internal WindowsetProjection that covers a single screen and contains all windowsets on that screen, regardless of the WM-specified projection. Depending on how the WM lays out its actual projections, multiple ScreenProjections may contain the same Windowsets.
