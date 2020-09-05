import CocoaLumberjackSwift
import Sentry

public class SentryLogger: NSObject, DDLogger {
  let minBreadcrumbLevel: UInt
  let minEventLevel: UInt
  public init(
    dsn: String? = nil,
    attachStacktrace: Bool = true,
    minBreadcrumbLevel: DDLogFlag = DDLogFlag.info,
    minEventLevel: DDLogFlag = DDLogFlag.error) {
    self.minBreadcrumbLevel = UInt(SentryLogger.toSentryLogLevel(ddLogLevel: minBreadcrumbLevel).rawValue)
    self.minEventLevel = UInt(SentryLogger.toSentryLogLevel(ddLogLevel: minEventLevel).rawValue)

    // If a DSN was provided here, we'll initialize the Sentry SDK with it:
    if let dsnString = dsn {
      SentrySDK.start { options in
        options.dsn = dsnString
        options.attachStacktrace = attachStacktrace ? 1 : 0
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

  static func toSentryLogLevel(ddLogLevel: DDLogFlag) -> SentryLevel {
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

  func toContextMap(message: DDLogMessage) -> [String: Any] {
    return [
      "thread id": message.threadID,
      "function": message.function ?? "unknown",
      "file name": message.fileName,
      "line": message.line
    ]
  }

  public func log(message: DDLogMessage) {
    let sentryLevel = SentryLogger.toSentryLogLevel(ddLogLevel: message.flag)
    let level = UInt(sentryLevel.rawValue)
    if level < minBreadcrumbLevel && level < self.minEventLevel {
      // If we're not recording a breadcrumb or capturing an event, nothing else to do.
      return
    }

    if let frmt = formatter {
      if let formatted = frmt.format(message: message) {
        if level >= self.minEventLevel {
          let event = Event()
          var context = [String: [String: Any]]()
          context["logger context"] = toContextMap(message: message)
          event.context = context
          // TODO: Add log support to logEntry
          event.message = formatted
          event.level = sentryLevel
          SentrySDK.capture(event: event)
        }

        if level >= self.minBreadcrumbLevel {
          let crumb = Breadcrumb()
          crumb.data = toContextMap(message: message)
          crumb.message = formatted
          crumb.level = sentryLevel
          crumb.category = "CocoaLumberjack"
          SentrySDK.addBreadcrumb(crumb: crumb)
        }
      }
    }
  }

  // TODO: replace with a call to SentrySDK.flush(2)
  public func flush() {
    // For now, on macOS to avoid flushing on app restart (i.e: console apps)
    #if os(macOS)
      sleep(2)
    #endif
  }
}

public class RawMessageLogFormatter: NSObject, DDLogFormatter {
  public func format(message: DDLogMessage) -> String? {
    return message.message
  }
}
