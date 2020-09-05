// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "SentryCocoaLumberjack",
    platforms: [
        .macOS(.v10_10), .iOS(.v9), .tvOS(.v9), .watchOS(.v2)
    ],
    dependencies: [
        .package(name: "Sentry", url: "https://github.com/getsentry/sentry-cocoa", from: "5.2.2"),
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack", from: "3.6.2")
    ],
    targets: [
        .target(
            name: "SentryCocoaLumberjack",
            dependencies: [ "Sentry", .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack")],
            exclude: [ "Example" ]),
        .testTarget(
            name: "SentryCocoaLumberjackTests",
            dependencies: ["SentryCocoaLumberjack"]),
        .target(
            name: "Example",
            dependencies: [
                "Sentry",
                "SentryCocoaLumberjack",
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack")],
            path: "Example")
    ]
)
