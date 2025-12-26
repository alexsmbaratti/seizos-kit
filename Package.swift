// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SeizosKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v14),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "SeizosCore",
            targets: ["SeizosCore"]
        ),
        .library(
            name: "SeizosUI",
            targets: ["SeizosUI"]
        ),
    ],
    targets: [
        .target(
            name: "SeizosCore"
        ),
        .target(
            name: "SeizosUI",
            dependencies: ["SeizosCore"]
        ),
        .testTarget(
            name: "SeizosCoreTests",
            dependencies: ["SeizosCore"]
        ),
    ]
)
