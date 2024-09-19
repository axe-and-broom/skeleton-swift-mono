// swift-tools-version: 5.6
import PackageDescription

let package = Package(
    name: "BuildTools",
    platforms: [.macOS(.v10_11)],
    dependencies: [
      .package(url: "https://github.com/yonaskolb/Mint", exact: "0.17.5"),
    ],
    targets: [
      .target(name: "BuildTools", path: "")
    ]
)