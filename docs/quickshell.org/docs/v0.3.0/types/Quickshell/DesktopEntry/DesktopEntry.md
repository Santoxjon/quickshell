# DesktopEntry

**Inherits**: `QtObject`

Represents a single desktop entry.

## Properties

-   **execString**: `string` - The raw `Exec` string from the desktop entry.
-   **genericName**: `string` - Short description of the application, such as “Web Browser”. May be empty.
-   **comment**: `string` - Long description of the application, such as “View websites on the internet”. May be empty.
-   **keywords**: `list<string>`
-   **id**: `string` (readonly)
-   **noDisplay**: `bool` - If true, this application should not be displayed in menus and launchers.
-   **startupClass**: `string` - Initial class or app id the app intends to use.
-   **name**: `string`
-   **icon**: `string` - Name of the icon associated with this application. May be empty.
-   **workingDirectory**: `string` - The working directory to execute from.
-   **runInTerminal**: `bool` - If the application should run in a terminal.
-   **categories**: `list<string>`
-   **command**: `list<string>` - The parsed `Exec` command in the desktop entry.
-   **actions**: `list<DesktopAction>` (readonly)

## Functions

-   **execute()**: `void` - Run the application.

