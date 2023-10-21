// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OneSignalFramework",
    products: [
        .library(
            name: "OneSignalFramework",
            targets: ["OneSignalFrameworkWrapper"]),
        .library(
            name: "OneSignalInAppMessages",
            targets: ["OneSignalInAppMessagesWrapper"]),
        .library(
            name: "OneSignalLocation",
            targets: ["OneSignalLocationWrapper"]),
        .library(
            name: "OneSignalExtension",
            targets: ["OneSignalExtensionWrapper"])
    ],
    targets: [
        .target(
            name: "OneSignalFrameworkWrapper",
            dependencies: [
                "OneSignalFramework",
                "OneSignalUser",
                "OneSignalNotifications",
                "OneSignalExtension",
                "OneSignalOutcomes",
                "OneSignalOSCore",
                "OneSignalCore"
            ],
            path: "OneSignalFrameworkWrapper"
        ),
        .target(
            name: "OneSignalInAppMessagesWrapper",
            dependencies: [
                "OneSignalInAppMessages",
                "OneSignalUser",
                "OneSignalNotifications",
                "OneSignalOutcomes",
                "OneSignalOSCore",
                "OneSignalCore"
            ],
            path: "OneSignalInAppMessagesWrapper"
        ),
        .target(
            name: "OneSignalLocationWrapper",
            dependencies: [
                "OneSignalLocation",
                "OneSignalUser",
                "OneSignalNotifications",
                "OneSignalOSCore",
                "OneSignalCore"
            ],
            path: "OneSignalLocationWrapper"
        ),
        .target(
            name: "OneSignalUserWrapper",
            dependencies: [
                "OneSignalUser",
                "OneSignalNotifications",
                "OneSignalExtension",
                "OneSignalOutcomes",
                "OneSignalOSCore",
                "OneSignalCore"
            ],
            path: "OneSignalUserWrapper"
        ),
        .target(
            name: "OneSignalNotificationsWrapper",
            dependencies: [
                "OneSignalNotifications",
                "OneSignalExtension",
                "OneSignalOutcomes",
                "OneSignalCore"
            ],
            path: "OneSignalNotificationsWrapper"
        ),
        .target(
            name: "OneSignalExtensionWrapper",
            dependencies: [
                "OneSignalExtension",
                "OneSignalOutcomes",
                "OneSignalCore"
            ],
            path: "OneSignalExtensionWrapper"
        ),
        .target(
            name: "OneSignalOutcomesWrapper",
            dependencies: [
                "OneSignalOutcomes",
                "OneSignalCore"
            ],
            path: "OneSignalOutcomesWrapper"
        ),
        .target(
            name: "OneSignalOSCoreWrapper",
            dependencies: [
                "OneSignalOSCore",
                "OneSignalCore"
            ],
            path: "OneSignalOSCoreWrapper"
        ),
        .binaryTarget(
          name: "OneSignalFramework",
          url: "https://github.com/Seebaro/OneSignal-iOS-SDK/releases/download/5.0.2/OneSignalFramework.xcframework.zip",
          checksum: "64a7fe3db7127729d6125fd4726f5f0d158d52c4f9c9bbf8a6261155d493eb47"
        ),
        .binaryTarget(
          name: "OneSignalInAppMessages",
          url: "https://github.com/Seebaro/OneSignal-iOS-SDK/releases/download/5.0.2/OneSignalInAppMessages.xcframework.zip",
          checksum: "18f3637bf8f3c3e8e0719995a5a9abd263f45f6368a80ca00abac58c770ee960"
        ),
        .binaryTarget(
          name: "OneSignalLocation",
          url: "https://github.com/Seebaro/OneSignal-iOS-SDK/releases/download/5.0.2/OneSignalLocation.xcframework.zip",
          checksum: "5e190901e62e943b0dece7ef30dd6210d8e5b8a4a855d04548451aeab4b39e16"
        ),
        .binaryTarget(
          name: "OneSignalUser",
          url: "https://github.com/Seebaro/OneSignal-iOS-SDK/releases/download/5.0.2/OneSignalUser.xcframework.zip",
          checksum: "273a113641a0a57de8f95f90158b2e966546b600b15a6726e40b7dc48b14572e"
        ),
        .binaryTarget(
          name: "OneSignalNotifications",
          url: "https://github.com/Seebaro/OneSignal-iOS-SDK/releases/download/5.0.2/OneSignalNotifications.xcframework.zip",
          checksum: "d98110f646702c353ac7ad90977560344b50397fe5d53bc9f987623db8556560"
        ),
        .binaryTarget(
          name: "OneSignalExtension",
          url: "https://github.com/Seebaro/OneSignal-iOS-SDK/releases/download/5.0.2/OneSignalExtension.xcframework.zip",
          checksum: "7b13dacf06ebec42ccb6d9c2b8a8d3908d92fbc1a2439451b9115b21fd4afdb1"
        ),
        .binaryTarget(
          name: "OneSignalOutcomes",
          url: "https://github.com/Seebaro/OneSignal-iOS-SDK/releases/download/5.0.2/OneSignalOutcomes.xcframework.zip",
          checksum: "a6a2b66377c84c003da813e8a6089fb3b90a55a149da22d654b11db65fe9de1b"
        ),
        .binaryTarget(
          name: "OneSignalOSCore",
          url: "https://github.com/Seebaro/OneSignal-iOS-SDK/releases/download/5.0.2/OneSignalOSCore.xcframework.zip",
          checksum: "2ece577dce8b81a07db77290d522a78c1bd245f8fa5028f9025a44b23f476c98"
        ),
        .binaryTarget(
          name: "OneSignalCore",
          url: "https://github.com/Seebaro/OneSignal-iOS-SDK/releases/download/5.0.2/OneSignalCore.xcframework.zip",
          checksum: "86edd8cd71a67e0940f6495f4019932ea0a0e8b89d3c8daecb50cd1717134167"
        )
    ]
)
