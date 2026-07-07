# SystemClock
**Inherits:** [QObject](https://doc.qt.io/qt-6/qobject.html)

System clock accessor.

It updates at hour, minute, or second intervals depending on `precision`.

## Properties
* `minutes` : `int` (readonly) - The current minute, or 0 if `precision` is `SystemClock.Hours`.
* `precision` : `SystemClock` - The precision the clock should measure at. Defaults to `SystemClock.Seconds`.
* `enabled` : `bool` - If the clock should update. Defaults to true.
* `seconds` : `int` (readonly) - The current second, or 0 if `precision` is `SystemClock.Hours` or `SystemClock.Minutes`.
* `date` : `date` (readonly) - The current date and time.
* `hours` : `int` (readonly) - The current hour.

## Variants
* `Minutes`
* `Seconds`
* `Hours`
