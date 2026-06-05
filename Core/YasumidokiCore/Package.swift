// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "YasumidokiCore",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(name: "YasumidokiCore", targets: ["YasumidokiCore"]),
    ],
    targets: [
        .target(name: "YasumidokiCore"),
        .testTarget(name: "YasumidokiCoreTests", dependencies: ["YasumidokiCore"]),
    ]
)
