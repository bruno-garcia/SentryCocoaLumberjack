import CocoaLumberjackSwift
import Sentry

public class SentryLogger: NSObject, DDLogger {
  public init(
    dsn: String? = nil,
    minBreadcrumbLevel: DDLogFlag = DDLogFlag.info,
    minErrorLevel: DDLogFlag = DDLogFlag.error) {
    // If a DSN was provided here, we'll initialize the Sentry SDK with it:
    if let dsnString = dsn {
      SentrySDK.start { options in
        options.dsn = dsnString
        options.attachStacktrace = true
        DDLogInfo("Initializing the Sentry SDK")
      }
    }
    // If no DSN was provided, this logger is disabled an nothing will be captured.
    // Unless the SDK is initialized elsewhere (i.e: SentrySDK.start)
  }

  var formatter: DDLogFormatter? = RawMessageLogFormatter()
  public var logFormatter: DDLogFormatter? {
    get { formatter }
    set { formatter = newValue }
  }

  func toSentryLogLevel(ddLogLevel: DDLogFlag) -> SentryLevel {
    switch ddLogLevel {
    case DDLogFlag.error:
      return SentryLevel.error
    case DDLogFlag.warning:
      return SentryLevel.warning
    case DDLogFlag.info:
      return SentryLevel.info
    case DDLogFlag.verbose, DDLogFlag.debug:
      return SentryLevel.debug
    default:
      return SentryLevel.info
    }
  }

  public func log(message: DDLogMessage) {
    if let frmt = formatter {
      if let formatted = frmt.format(message: message) {
        let event = Event()
        // TODO: Add log support to logEntry
        var context = [String: [String: Any]]()
        context["logger context"] = [
          "thread id": message.threadID,
          "function": message.function,
          "file name": message.fileName,
          "line": message.line,
        ]
        event.context = context
        event.message = formatted
        event.level = toSentryLogLevel(ddLogLevel: message.flag)
        SentrySDK.capture(event: event)
      }
    }
  }

  // TODO: replace with a call to SentrySDK.flush(2)
  public func flush() {
    // For now, on macOS to avoid flushing on app restart (i.e: console apps)
    if #available(macOS 10.10, *) {
      sleep(2)
    }
  }
}

public class RawMessageLogFormatter: NSObject, DDLogFormatter {
  public func format(message: DDLogMessage) -> String? {
    return message.message
  }
}
