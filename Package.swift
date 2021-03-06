// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sculpture",
    platforms: [.macOS(.v10_15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Sculpture",
            targets: ["Sculpture"]),
        .library(
            name: "SculptureNetwork",
            targets: ["SculptureNetwork"]),
        .library(
            name: "SculptureGenerate",
            targets: ["SculptureGenerate"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "Datable", url: "https://github.com/OperatorFoundation/Datable", from: "3.1.4"),
        .package(name: "Transmission", url: "https://github.com/OperatorFoundation/Transmission", from: "1.2.3"),
        .package(name: "Gardener", url: "https://github.com/OperatorFoundation/Gardener", branch: "main"),
        .package(url: "https://github.com/blanu/Focus.git", .branch("main")),
        .package(url: "https://github.com/OperatorFoundation/SwiftHexTools.git", from: "1.2.5"),
        .package(url: "https://github.com/apple/swift-crypto", from: "2.0.0"),
        .package(url: "https://github.com/OperatorFoundation/Abacus", branch: "main"),
        .package(url: "https://github.com/swift-server/swift-backtrace.git", from: "1.3.1"),
        .package(url: "https://github.com/onevcat/Rainbow", .upToNextMajor(from: "4.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Sculpture",
            dependencies: ["Datable", "Focus", "SwiftHexTools", "Gardener", "Abacus", "Rainbow",
               .product(name: "Crypto", package: "swift-crypto")
            ]
        ),
        .target(
            name: "SculptureNetwork",
            dependencies: ["Sculpture", "Datable", "Transmission",
                .product(name: "Crypto", package: "swift-crypto")
            ]
        ),
        .target(
            name: "SculptureGenerate",
            dependencies: ["Sculpture", "Datable", "Gardener"]),
        .testTarget(
            name: "SculptureTests",
            dependencies: [
                "Sculpture", "Rainbow",
                .product(name: "Backtrace", package: "swift-backtrace")
            ]),
        .testTarget(
            name: "SculptureNetworkTests",
            dependencies: ["SculptureNetwork"]),
    ],
    swiftLanguageVersions: [.v5]
)
