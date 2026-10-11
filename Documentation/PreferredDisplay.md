# Preferred launcher display

This fork supports an optional `preferredDisplayID` setting so that opening the
launcher does not cover the monitor where you are working.

Set it while LaunchNext is quit, using the numeric macOS display ID:

```sh
defaults write com.roversx.launchnext preferredDisplayID -string '<display ID>'
```

LaunchNext uses that display for both fullscreen and compact mode. If it is
disconnected, it falls back to the display under the mouse pointer.

To restore the original pointer-based behavior, quit LaunchNext and run:

```sh
defaults delete com.roversx.launchnext preferredDisplayID
```

The setting affects only LaunchNext; it does not change macOS's main display,
monitor arrangement, or any other application's windows.
