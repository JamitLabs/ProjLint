// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "ProjLint",
    platforms: [
        .macOS(.v10_11),
    ],
    products: [
        .executable(name: "projlint", targets: ["ProjLint"]),
        .library(name: "ProjLintKit", targets: ["ProjLintKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/kiliankoe/CLISpinner.git", .upToNextMinor(from: "0.3.5")),
        .package(url: "https://github.com/Dschee/Difference.git", .branch("master")),
        .package(url: "https://github.com/Flinesoft/HandySwift.git", .upToNextMajor(from: "2.6.0")),
        .package(url: "https://github.com/onevcat/Rainbow.git", .upToNextMajor(from: "3.1.4")),
        .package(url: "https://github.com/stencilproject/Stencil.git", .upToNextMajor(from: "0.11.0")),
        .package(url: "https://github.com/jakeheis/SwiftCLI.git", .upToNextMajor(from: "5.1.2")),
        .package(url: "https://github.com/tuist/xcodeproj.git", .upToNextMajor(from: "6.0.1")),
        .package(url: "https://github.com/jpsim/Yams.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "ProjLint",
            dependencies: ["ProjLintKit"]
        ),
        .target(
            name: "ProjLintKit",
            dependencies: [
                "CLISpinner",
                "Difference",
                "HandySwift",
                "Rainbow",
                "Stencil",
                "SwiftCLI",
                "xcodeproj",
                "Yams"
            ]
        ),
        .testTarget(
            name: "ProjLintKitTests",
            dependencies: ["ProjLintKit", "HandySwift"]
        )
    ]
)
