// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "open_wearables_health_sdk",
    platforms: [.iOS("15.0")],
    products: [
        .library(name: "open-wearables-health-sdk", targets: ["open_wearables_health_sdk"]),
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        // dial203 fork: HRV RMSSD, readiness input types and beat-to-beat capture. Pinned to a commit so
        // every build maps to one SDK revision.
        .package(
            url: "https://github.com/Michael-Dial/open_wearables_ios_sdk.git",
            revision: "d8cf10016ba32c1d2ba84238e298e5dee18089ab"
        ),
    ],
    targets: [
        .target(
            name: "open_wearables_health_sdk",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "OpenWearablesHealthSDK", package: "open_wearables_ios_sdk"),
            ],
            resources: [.process("Resources")],
        ),
    ]
)
