# NotificationServer

**Version:** v0.3.0

**Description:**
Desktop Notifications Server.

This provides a server that can be used to receive notifications from external applications.

The server does not advertise most capabilities by default. See the individual properties for details.

## Properties
* `inlineReplySupported`: bool
* `bodySupported`: bool
* `bodyImagesSupported`: bool
* `bodyMarkupSupported`: bool
* `keepOnReload`: bool
* `persistenceSupported`: bool
* `actionsSupported`: bool
* `bodyHyperlinksSupported`: bool
* `trackedNotifications`: ObjectModel<Notification>
* `imageSupported`: bool
* `extraHints`: list<string>
* `actionIconsSupported`: bool

## Signals
* `notification(notification)`
