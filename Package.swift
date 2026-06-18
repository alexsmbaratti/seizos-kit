// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SeizosKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v14),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SeizosKit",
            targets: ["SeizosKit"]
        ),
    ],
    targets: [
        .target(
            name: "SeizosKit",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "SeizosKitTests",
            dependencies: ["SeizosKit"]
        ),
    ]
)
