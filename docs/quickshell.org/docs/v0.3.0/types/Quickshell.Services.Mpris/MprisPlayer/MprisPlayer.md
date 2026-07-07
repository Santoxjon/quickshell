# MprisPlayer

**Version:** v0.3.0

**Description:**
A media player exposed over MPRIS.

## Properties
*   `supportedMimeTypes`: list<string> (readonly)
*   `trackArtist`: string (readonly)
*   `trackArtists`: string (readonly)
*   `canControl`: bool (readonly)
*   `canRaise`: bool (readonly)
*   `positionSupported`: bool (readonly)
*   `canPause`: bool (readonly)
*   `isPlaying`: bool
*   `shuffle`: bool
*   `canQuit`: bool (readonly)
*   `desktopEntry`: string (readonly)
*   `canSeek`: bool (readonly)
*   `rate`: real
*   `loopSupported`: bool (readonly)
*   `canPlay`: bool (readonly)
*   `volumeSupported`: bool (readonly)
*   `canGoNext`: bool (readonly)
*   `length`: real (readonly)
*   `lengthSupported`: bool (readonly)
*   `playbackState`: MprisPlaybackState
*   `dbusName`: string (readonly)
*   `shuffleSupported`: bool (readonly)
*   `loopState`: MprisLoopState
*   `metadata`: unknown (readonly)
*   `trackArtUrl`: string (readonly)
*   `canTogglePlaying`: bool (readonly)
*   `fullscreen`: bool
*   `identity`: string (readonly)
*   `trackAlbum`: string (readonly)
*   `trackAlbumArtist`: string (readonly)
*   `canGoPrevious`: bool (readonly)
*   `position`: real
*   `trackTitle`: string (readonly)
*   `uniqueId`: int (readonly)
*   `maxRate`: real (readonly)
*   `minRate`: real (readonly)
*   `canSetFullscreen`: bool (readonly)
*   `volume`: real

## Functions
*   `openUri(uri)`
*   `seek(offset)`
*   `setPosition(position)`
*   `playPause()`
*   `stop()`
*   `next()`
*   `previous()`
*   `raise()`
*   `quit()`
*   `play()`
*   `pause()`

## Signals
*   `seeked(position)`
*   `positionChanged()`
*   `trackChanged()`
*   `playerVanished()`
