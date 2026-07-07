# FileView

**Inherits:** [QtObject](https://doc.qt.io/qt-6/qobject.html)

Simple accessor for small files.

This type is intended for reading and writing small files, and is not suitable for large files.
It can read files as text or as an ArrayBuffer. Text is decoded as UTF-8, which should be suitable for most text files.

#### Example: Reading a JSON as text
```qml
FileView {
  id: jsonFile
  path: Qt.resolvedUrl("./your.json")
  // Forces the file to be loaded by the time we call JSON.parse().
  // see blockLoading's property documentation for details.
  blockLoading: true
}

readonly property var jsonData: JSON.parse(jsonFile.text())
```
Also see [JsonAdapter](../JsonAdapter/JsonAdapter.md) for an alternative way to handle reading and writing JSON files.

## Properties

- **path**: *string* - The path to the file that should be read, or an empty string to unload the file.
- **adapter**: *FileViewAdapter* - In addition to directly reading/writing the file as text, *adapters* can be used to expose a file’s content in new ways. An adapter will automatically be given the loaded file’s content. Its state may be saved with `writeAdapter()`. Currently the only adapter is [JsonAdapter](../JsonAdapter/JsonAdapter.md).
- **blockAllReads**: *bool* - If `text()` and `data()` should block all operations while a file loads. Defaults to false. This is nearly identical to `blockLoading`, but will additionally block when a file is loaded and `path` changes.
- **blockWrites**: *bool* - If true (default false), all calls to `setText()` or `setData()` will block the UI thread until the write succeeds or fails.
- **printErrors**: *bool* - If true (default), read or write errors will be printed to the quickshell logs. If false, all known errors will not be printed.
- **loaded**: *bool* (readonly) - If a file is currently loaded, which may or may not be the one currently specified by `path`.
- **blockLoading**: *bool* - If `text()` and `data()` should block all operations until the file is loaded. Defaults to false.
- **preload**: *bool* - If the file should be loaded in the background immediately when set. Defaults to true.
- **watchChanges**: *bool* - If true (default false), `fileChanged()` will be called whenever the content of the file changes on disk, including when `setText()` or `setData()` are used.
- **atomicWrites**: *bool* - If true (default), all calls to `setText()` or `setData()` will be performed atomically, meaning if the write fails for any reason, the file will not be modified.

## Functions

- **data**(): *unknown* - Returns the data of the file specified by `path` as an [ArrayBuffer](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer).
- **reload**(): *void* - Unload the loaded file and reload it, usually in response to changes.
- **setData**(`data`): *void* - Sets the content of the file specified by `path` as an [ArrayBuffer].
- **setText**(`text`): *void* - Sets the content of the file specified by `path` as text.
- **text**(): *string* - Returns the data of the file specified by `path` as text.
- **waitForJob**(): *bool* - Block all operations until the currently running load completes.
- **writeAdapter**(): *void* - Write the content of the current `adapter` to the selected file.

## Signals

- **loadFailed**(`error`)
  - `error`: *FileViewError*
  
  Emitted if the file failed to load.
- **adapterUpdated**()
  
  Emitted when the active `adapter`’s data is changed.
- **saveFailed**(`error`)
  - `error`: *FileViewError*
  
  Emitted if the file failed to save.
- **fileChanged**()
  
  Emitted when the file on disk has changed.
- **loaded**()
  
  Emitted when the file has been loaded.
- **saved**()
  
  Emitted when the file has been saved.
