# SentryCocoaLumberjack

Send your [`CocoaLumberjack`](https://github.com/CocoaLumberjack/CocoaLumberjack) log messages to [Sentry](https://sentry.io).

## Using this library

Install it with Swift Package Manager

```swift
.package(url: "https://github.com/bruno-garcia/SentryCocoaLumberjack", from: "0.0.1-alpha.2")
```

Add the Sentry logger to your app:

```swift
let sentryLogger = SentryLogger()
DDLog.add(sentryLogger, with: DDLogLevel.info)
```

Done. All log messages with level `info` or higher will be stored as breadcrumbs.
Logs with level `error` send an event to Sentry, which include the breadcrumbs.

These log levels can be configured. Check out the [example console app in this repo](Example/main.swift).

## Run the example

First add your DSN to [Example/main.swift](Example/main.swift).

Run it:

```sh
swift run

2020-09-05 20:39:59:741 Example[74424:4634517] 🔊 Noise message again: Something trivial.
2020-09-05 20:39:59:741 Example[74424:4634517] 🌍 Check this out, something's weird.
2020-09-05 20:39:59:741 Example[74424:4634517] 🪓🌴 Something relevant happened. Be aware.
2020-09-05 20:39:59:741 Example[74424:4634517] 🍁 Warning! This isn't good.
2020-09-05 20:39:59:741 Example[74424:4634517] 🔥 Broken stuff! Please fix this!
```

The example is configured with custom minimum levels so you can see `info`, `warning` and `error` level events sent to Sentry. 
All levels are stored as breadcrumbs.

## A low quality `gif` to give you an idea

![Running the example](.github/sentry-cocoalumberjack.gif)
