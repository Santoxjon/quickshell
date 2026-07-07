# EasingCurve

**Inherits**: `QtObject`

Easing curve.

## Properties

-   **curve**: `EasingCurve` - Easing curve settings. Works exactly the same as `PropertyAnimation.easing`.

## Functions

-   **interpolate(x, a, b)**: `real` - Interpolate between `a` and `b` at `x`.
-   **interpolate(x, a, b)**: `point` - Interpolate between `a` and `b` at `x`.
-   **interpolate(x, a, b)**: `rect` - Interpolate between `a` and `b` at `x`.
-   **valueAt(x)**: `real` - Returns the Y value for the given X value on the curve from 0.0 to 1.0.
