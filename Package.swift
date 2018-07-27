// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "ProjLint",
    products: [
        .executable(name: "projlint", targets: ["ProjLint"]),
        .library(name: "ProjLintKit", targets: ["ProjLintKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/kiliankoe/CLISpinner.git", .upToNextMinor(from: "0.3.5")),
        .package(url: "https://github.com/Flinesoft/HandySwift.git", .upToNextMajor(from: "2.6.0")),
        .package(url: "https://github.com/onevcat/Rainbow.git", .upToNextMajor(from: "3.1.4")),
        .package(url: "https://github.com/jakeheis/SwiftCLI", .upToNextMajor(from: "5.1.2"))
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
                "HandySwift",
                "Rainbow",
                "SwiftCLI"
            ]
        ),
        .testTarget(
            name: "ProjLintKitTests",
            dependencies: ["ProjLintKit"]
        )
    ]
)
