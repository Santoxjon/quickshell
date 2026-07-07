# Region

**Inherits:** [QObject](https://doc.qt.io/qt-6/qobject.html)

A composable region used as a mask.

## Properties

- `topRightRadius` : `int` - Top-right corner radius. Only applies when `shape` is `Rect`. Defaults to `radius`, and may be reset by assigning `undefined`.
- `intersection` : `Intersection` - The way this region interacts with its parent region. Defaults to `Combine`.
- `bottomLeftRadius` : `int` - Bottom-left corner radius. Only applies when `shape` is `Rect`. Defaults to `radius`, and may be reset by assigning `undefined`.
- `height` : `int` - Defaults to 0. Does nothing if `item` is set.
- `item` : `Item` - The item that determines the geometry of the region. `item` overrides `x`, `y`, `width` and `height`.
- `bottomRightRadius` : `int` - Bottom-right corner radius. Only applies when `shape` is `Rect`. Defaults to `radius`, and may be reset by assigning `undefined`.
- `topLeftRadius` : `int` - Top-left corner radius. Only applies when `shape` is `Rect`. Defaults to `radius`, and may be reset by assigning `undefined`.
- `width` : `int` - Defaults to 0. Does nothing if `item` is set.
- `radius` : `int` - Corner radius for rounded rectangles. Only applies when `shape` is `Rect`. Defaults to 0. Acts as the default for `topLeftRadius`, `topRightRadius`, `bottomLeftRadius`, and `bottomRightRadius`.
- `regions` : `list<Region>` - (readonly) Regions to apply on top of this region.
- `shape` : `RegionShape` - Defaults to `Rect`.
- `x` : `int` - Defaults to 0. Does nothing if `item` is set.
- `y` : `int` - Defaults to 0. Does nothing if `item` is set.

## Signals

- `changed()` - Triggered when the region’s geometry changes. In some cases the region does not update automatically. In those cases you can emit this signal manually.
- `childrenChanged()` - No details provided.
