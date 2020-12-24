// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "StayTunedSDK",
    platforms: [
        .iOS(.v11), .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "StayTunedSDK",
            targets: ["StayTunedSDK"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "StayTunedSDK",
            path: "StayTunedSDK.xcframework"
        )
    ]
)
