# Quickshell

## Properties

- `workingDirectory` : `string` - Quickshell’s working directory. Defaults to whereever quickshell was launched from.
- `stateDir` : `string` - (readonly) The per-shell state directory.
- `dataDir` : `string` - (readonly) The per-shell data directory.
- `watchFiles` : `bool` - If true then the configuration will be reloaded whenever any files change. Defaults to true.
- `clipboardText` : `string` - The system clipboard.
- `processId` : `int` - (readonly) Quickshell’s process id.
- `configDir` : `string` - (readonly) Deprecated: Renamed to `shellDir` for clarity.
- `screens` : `list<ShellScreen>` - (readonly) All currently connected screens.
- `shellDir` : `string` - (readonly) The full path to the root directory of your shell.
- `cacheDir` : `string` - (readonly) The per-shell cache directory.
- `shellRoot` : `string` - (readonly) Deprecated: Renamed to `shellDir` for consistency.

## Functions

- `cachePath(path)` : `string` - Equivalent to `${Quickshell.cacheDir}/${path}`
- `configPath(path)` : `string` - Deprecated: Renamed to `shellPath()` for clarity.
- `dataPath(path)` : `string` - Equivalent to `${Quickshell.dataDir}/${path}`
- `env(variable)` : `variant` - Returns the string value of an environment variable or null if it is not set.
- `execDetached(context)` : `void` - Launch a process detached from Quickshell.
- `hasQtVersion(major, minor)` : `bool` - Check if Qt’s version is at least `major.minor`.
- `hasThemeIcon(icon)` : `bool` - Check if specified icon has an available icon in your icon theme
- `hasVersion(major, minor, features)` : `bool` - Check if Quickshell’s version is at least `major.minor` and all of the given unreleased features are available.
- `hasVersion(major, minor)` : `bool`
- `iconPath(icon)` : `string` - Returns a string usable for a `Image.source` for a given system icon.
- `iconPath(icon, check)` : `string`
- `iconPath(icon, fallback)` : `string`
- `inhibitReloadPopup()` : `void` - When called from `reloadCompleted()` or `reloadFailed()`, prevents the default reload popup from displaying.
- `reload(hard)` : `void` - Reload the shell.
- `shellPath(path)` : `string` - Equivalent to `${Quickshell.configDir}/${path}`
- `statePath(path)` : `string` - Equivalent to `${Quickshell.stateDir}/${path}`

## Signals

- `lastWindowClosed()` - Sent when the last window is closed.
- `reloadCompleted()` - The reload sequence has completed successfully.
- `reloadFailed(errorString)` - The reload sequence has failed.
