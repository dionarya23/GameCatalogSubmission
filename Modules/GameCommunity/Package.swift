// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GameCommunity",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "GameCommunity",
            targets: ["GameCommunity"]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "10.29.0")),
        .package(path: "../Core")
    ],
    targets: [
        .target(
          name: "GameCommunity",
          dependencies: [
            .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
            .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
            "Core"
          ]),

        .testTarget(
            name: "GameCommunityTests",
            dependencies: ["GameCommunity"]),
    ]
)
