# DesktopAction

**Inherits**: `QtObject`

Represents a single action from a desktop entry.

## Properties

- `id`: `string` (readonly)
- `execString`: `string` - The raw `Exec` string from the action.
- `name`: `string`
- `icon`: `string`
- `command`: `list<string>` - The parsed `Exec` command in the action.

## Functions

- `execute()`: `void` - Run the application.
