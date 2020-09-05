import SentryCocoaLumberjack
import CocoaLumberjackSwift

// Works in combination with other loggers:
DDLog.add(DDASLLogger.sharedInstance)
if #available(iOS 10.0, macOS 10.12, *) {
  DDLog.add(DDOSLogger.sharedInstance)
}
if let ddtty = DDTTYLogger.sharedInstance {
  DDLog.add(ddtty)
}

// You can initialize Sentry separately (call 'SentrySDK.start') and to create the logger, simply:
//let sentryLogger = SentryLogger()

// Or have the logger initalize Sentry for you, by providing the DSN:
let sentryLogger = SentryLogger(
    // ***** NOTE: Replace it with your DSN to see the example events in your Sentry project. *****
    dsn: "https://fb5aa4ff267e49449e898fad268f57ea@o117736.ingest.sentry.io/5418677",
    // Optionally opt-out of including the stack trace. Be aware: it's used to group events together.
    attachStacktrace: true,
    // Optionally override the minimum level a log message must have to be kept as a crumb.
    minBreadcrumbLevel: DDLogFlag.verbose, // Default is info
    // Optionally override the minimum level a log message must have to be sent to Sentry as event.
    minEventLevel: DDLogFlag.info) // Default is error

// Add Sentry to CocoaLumberjack
// NOTE: The min level here has to be equal or lower the levels used for Breadcrumb or Event:
DDLog.add(sentryLogger, with: DDLogLevel.debug)

// Kept as breadcrumbs
DDLogVerbose("🔊 Noise message again: Something trivial.")
DDLogDebug("🌍 Check this out, something's weird.")

// Becomes an event in Sentry, including the previous messages as breadcrumbs.
DDLogInfo("🪓🌴 Something relevant happened. Be aware.")

// Also becomes an event, breadcrumbs also include past log entries, like the info above.
DDLogWarn("🍁 Warning! This isn't good.")
DDLogError("🔥 Broken stuff! Please fix this!")
