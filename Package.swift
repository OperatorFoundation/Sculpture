// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#if os(macOS) || os(iOS)
let package = Package(
    name: "Sculpture",
    platforms: [.macOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Sculpture",
            targets: ["Sculpture"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "Datable", url: "https://github.com/OperatorFoundation/Datable", from: "3.1.0"),
        .package(name: "Transmission", url: "https://github.com/OperatorFoundation/Transmission", from: "0.4.1"),
        .package(name: "TransmissionLinux", url: "https://github.com/OperatorFoundation/TransmissionLinux", from: "0.4.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Sculpture",
            dependencies: ["Datable", "Transmission"]),
        .testTarget(
            name: "SculptureTests",
            dependencies: ["Sculpture"]),
    ],
    swiftLanguageVersions: [.v5]
)
#else
let package = Package(
    name: "Sculpture",
    platforms: [.macOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Sculpture",
            targets: ["Sculpture"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "Datable", url: "https://github.com/OperatorFoundation/Datable", from: "3.1.0"),
        .package(name: "Transmission", url: "https://github.com/OperatorFoundation/Transmission", from: "0.4.1"),
        .package(name: "TransmissionLinux", url: "https://github.com/OperatorFoundation/TransmissionLinux", from: "0.4.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Sculpture",
            dependencies: ["Datable", "TransmissionLinux"]),
        .testTarget(
            name: "SculptureTests",
            dependencies: ["Sculpture"]),
    ],
    swiftLanguageVersions: [.v5]
)
#endif
