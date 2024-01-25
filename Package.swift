// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RHNetworkAPI",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "RHNetworkAPI",
            targets: ["RHNetworkAPI"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/HsinChungHan/RHNetwork.git",
            branch: "main")
    ],
    targets: [
        .target(
            name: "RHNetworkAPI",
            dependencies: ["RHNetwork"]),
        .testTarget(
            name: "RHNetworkAPITests",
            dependencies: ["RHNetworkAPI"]),
        .testTarget(
            name: "RHNetworkAPITests_EndToEndTests",
            dependencies: ["RHNetworkAPI"]),
    ]
)
