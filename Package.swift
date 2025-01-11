// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "mocketserver", // The name of your package
    platforms: [
        .macOS(.v13) // Specify the minimum macOS version your package supports
    ],
    products: [
        .library(
            name: "MocketServer", // This is the name of the library product
            targets: ["MocketServer"] // This is the target defined below
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"), // Add Vapor as a dependency
    ],
    targets: [
        .target(
            name: "MocketServer", // The target for your WebSocket server
            dependencies: [
                .product(name: "Vapor", package: "vapor") // Link Vapor as a dependency for this target
            ]
        ),
        .testTarget(
            name: "MocketServerTests", // The test target for your package
            dependencies: ["MocketServer"] // The test target depends on the main MocketServer target
        ),
    ]
)
