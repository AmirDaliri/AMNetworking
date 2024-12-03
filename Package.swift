// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AMNetworking",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "AMNetworking",
            targets: ["AMNetworking"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AMNetworking",
            dependencies: [],
            path: "Sources/AMNetworking",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "AMNetworkingTests",
            dependencies: ["AMNetworking"],
            path: "Tests/AMNetworkingTests"
        )
    ]
)
