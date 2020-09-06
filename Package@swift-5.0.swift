// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SentryCocoaLumberjack",
    platforms: [
        .macOS(.v10_10), .iOS(.v9), .tvOS(.v9), .watchOS(.v3)
    ],
    products: [.library(name: "SentryCocoaLumberjack",
                    targets: ["SentryCocoaLumberjack"])],
    dependencies: [
        .package(url: "https://github.com/getsentry/sentry-cocoa", from: "5.2.2"),
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack", from: "3.6.2")
    ],
    targets: [
        .target(
            name: "SentryCocoaLumberjack",
            dependencies: [ "Sentry", .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack")],
            exclude: [ "Example" ]),
        .target(
            name: "Example",
            dependencies: [
                "Sentry",
                "SentryCocoaLumberjack",
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack")],
            path: "Example")
    ]
)
