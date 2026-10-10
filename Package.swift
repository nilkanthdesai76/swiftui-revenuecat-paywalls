// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "RevenueCatPaywalls",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "RevenueCatPaywalls",
            targets: ["RevenueCatPaywalls"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/RevenueCat/purchases-ios.git", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "RevenueCatPaywalls",
            dependencies: [
                .product(name: "RevenueCat", package: "purchases-ios")
            ],
            path: "Sources/RevenueCatPaywalls"
        ),
        .testTarget(
            name: "RevenueCatPaywallsTests",
            dependencies: ["RevenueCatPaywalls"],
            path: "Tests/RevenueCatPaywallsTests"
        ),
    ]
)
