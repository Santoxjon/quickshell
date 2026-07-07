# LazyLoader

**Inherits**: `QtObject`

Asynchronous component loader.

This component is used to load other components asynchronously, preventing them from blocking the UI thread. This is useful for components that aren’t created immediately, such as windows that aren’t visible until triggered by another action. It works on creating the component in the gaps between frame rendering to prevent blocking the interface thread. It can also be used to preserve memory by loading components only when you need them and unloading them afterward.

Note that when reloading the UI due to changes, lazy loaders will always load synchronously so windows can be reused.

## Properties

-   `activeAsync`: `bool`
    If the component is fully loaded. Setting this property to true will asynchronously load the component similarly to `loading`. Reading it or setting it to false will behave the same as `active`.

-   `source`: `string`
    The URI to load the component from. Mutually exclusive to `component`.

-   `active`: `bool`
    If the component is fully loaded. Setting this property to `true` will force the component to load to completion, blocking the UI, and setting it to `false` will destroy the component, requiring it to be loaded again. See also: `activeAsync`.

-   `item`: `QtObject` (readonly)
    The fully loaded item if the loader is `loading` or `active`, or `null` if neither `loading` nor `active`. Note that the item is owned by the LazyLoader, and destroying the LazyLoader will destroy the item.

-   `component`: `Component` (default)
    The component to load. Mutually exclusive to `source`.

-   `loading`: `bool`
    If the loader is actively loading. If the component is not loaded, setting this property to true will start loading it asynchronously. If the component is already loaded, setting this property has no effect. See also: `activeAsync`.
