# FileViewError

**Inherits:** [QtObject](https://doc.qt.io/qt-6/qml-object.html)

Error values for [FileView](../FileView/FileView.md).

## Functions

- **toString**(value) : `string`
  
  Returns a string representation of a `FileViewError` value.

## Variants

- **FileNotFound**
  
  The file to read does not exist.

- **Success**
  
  No error occurred.

- **PermissionDenied**
  
  Permission to read/write the file was not granted.

- **Unknown**
  
  An unknown error occurred. Check the logs for details.

- **NotAFile**
  
  The specified path to read/write exists and was not a file.
