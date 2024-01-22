// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription



let package = Package(
    name: "MiseboxiOSPackage",
    platforms: [
        .iOS(.v13) // Ensure your platform version is correct
    ],
    products: [
        .library(
            name: "MiseboxiOSPackage",
            targets: ["MiseboxiOSPackage"]
        ),
    ],
    dependencies: [
        // Add Firebase as a dependency
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.19.1") // Replace X.X.X with the desired version
    ],
    targets: [
        .target(
            name: "MiseboxiOSPackage",
            dependencies: [
                // Add FirebaseAuth as a dependency for your target
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk")
            ]
        ),
        .testTarget(
            name: "MiseboxiOSPackageTests",
            dependencies: ["MiseboxiOSPackage"]
        ),
    ]
)
