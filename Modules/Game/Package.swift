// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Game",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Game",
            targets: ["Game"]),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/realm-swift.git", branch: "master"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.2.0")),
        .package(path: "../Core")
    ],
    targets: [
        .target(
            name: "Game",
            dependencies: [
                .product(name: "RealmSwift", package: "realm-swift"),
                "Core",
                "Alamofire"
            ]
        ),
        .testTarget(
            name: "GameTests",
            dependencies: ["Game"]),
    ]
)
