# ElapsedTimer

**Inherits**: `QtObject`

Measures time between events. This is a simple wrapper around `QElapsedTimer` for determining the time between events that don’t supply it.

## Functions

-   **elapsed()**: `real` - Return the number of seconds since the timer was last started or restarted, with nanosecond precision.
-   **elapsedMs()**: `int` - Return the number of milliseconds since the timer was last started or restarted.
-   **elapsedNs()**: `int` - Return the number of nanoseconds since the timer was last started or restarted.
-   **restart()**: `real` - Restart the timer, returning the number of seconds since the timer was last started or restarted, with nanosecond precision.
-   **restartMs()**: `int` - Restart the timer, returning the number of milliseconds since the timer was last started or restarted.
-   **restartNs()**: `int` - Restart the timer, returning the number of nanoseconds since the timer was last started or restarted.
