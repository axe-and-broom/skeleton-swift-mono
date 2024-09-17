// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// ⚠️ GENERATED FILE ⚠️
//
// This file was automatically generated and should not be edited.
// To update this file, run `rake generate` and your changes will be reflected.
//
// ⚠️ GENERATED FILE ⚠️

import PackageDescription

let package = Package(
    name: "AppEnvironment",
    platforms: [
        .iOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        .library(
            name: "AppEnvironment",
            targets: ["AppEnvironment"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AppEnvironment",
            dependencies: [
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "AppEnvironmentTests",
            dependencies: [
                "AppEnvironment",
            ],
            path: "Tests"
        )
    ]
)
