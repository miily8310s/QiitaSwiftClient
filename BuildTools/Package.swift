// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "BuildTools",
    platforms: [.macOS(.v10_13)],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.54.0"),
        .package(url: "https://github.com/realm/SwiftLint.git", branch: "main")
    ],
    targets: [.target(name: "BuildTools", path: "")]
)