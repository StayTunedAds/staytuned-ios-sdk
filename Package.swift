
// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "StayTuned",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "StayTuned",
            targets: ["StayTuned"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "StayTuned",
            path: "https://github.com/StayTunedAds/staytuned-ios-sdk/releases/download/1.0.16/StayTunedSDK.xcframework.zip"
        )
    ]
)
