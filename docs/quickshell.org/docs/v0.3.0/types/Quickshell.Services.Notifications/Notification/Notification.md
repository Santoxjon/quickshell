# Notification

**Version:** v0.3.0

**Description:**
A notification emitted by a NotificationServer.

## Properties
*   `body`: string (readonly)
*   `inlineReplyPlaceholder`: string (readonly)
*   `actions`: list<NotificationAction> (readonly)
*   `image`: string (readonly)
*   `resident`: bool (readonly)
*   `summary`: string (readonly)
*   `id`: int (readonly)
*   `tracked`: bool
*   `hasActionIcons`: bool (readonly)
*   `hasInlineReply`: bool (readonly)
*   `appName`: string (readonly)
*   `hints`: unknown (readonly)
*   `appIcon`: string (readonly)
*   `lastGeneration`: bool (readonly)
*   `desktopEntry`: string (readonly)
*   `expireTimeout`: real (readonly)
*   `urgency`: NotificationUrgency (readonly)
*   `transient`: bool (readonly)

## Functions
*   `dismiss()`
*   `expire()`
*   `sendInlineReply(replyText)`

## Signals
*   `closed(reason)`
