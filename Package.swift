// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MiseboxiOSPackage",
    platforms: [
            .iOS(.v13)  // Set the minimum deployment target to iOS 13
        ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MiseboxiOSPackage",
            targets: ["MiseboxiOSPackage"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MiseboxiOSPackage"),
        .testTarget(
            name: "MiseboxiOSPackageTests",
            dependencies: ["MiseboxiOSPackage"]),
    ]
)
