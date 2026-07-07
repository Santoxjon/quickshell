# ScreenProjection
**Version:** v0.3.0
**Description:** WindowsetProjection covering one specific screen.

A `ScreenProjection` is a special type of `WindowsetProjection` that combines all windowsets across all projections covering a specific screen.

When used with `Windowset.setProjection()`, an arbitrary projection on the screen will be picked. Usually there is only one.

Use `WindowManager.screenProjection()` to get a `ScreenProjection` for a given screen.
