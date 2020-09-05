# SentryCocoaLumberjack

Send your [`CocoaLumberjack`](https://github.com/CocoaLumberjack/CocoaLumberjack) log messages to Sentry.


# Run the example

Add your DSN to [Example/main.swift](Example/main.swift).

Run it:
```sh
swift run

2020-09-05 17:03:52:724 Example[36493:4387558] Initializing the Sentry SDK
2020-09-05 17:03:52:731 Example[36493:4387558] 🔊 Noise message again: Something trivial happened.
2020-09-05 17:03:52:731 Example[36493:4387558] 🌍 You might want to look into this if something's weird.
2020-09-05 17:03:52:731 Example[36493:4387558] 🪓🌴 Something relevant happened. Always be aware.
2020-09-05 17:03:52:731 Example[36493:4387558] 🍁 Warning! This isn't good.
2020-09-05 17:03:52:731 Example[36493:4387558] 🔥 Broken stuff! Please fix this!
```
