// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SeizosKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v15),
        .watchOS(.v11),
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
