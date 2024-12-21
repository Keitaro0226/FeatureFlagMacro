// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "FeatureFlag",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "FeatureFlagMacro",
            targets: ["FeatureFlagMacro"]
        ),
        .executable(
            name: "FeatureFlagMacroClient",
            targets: ["FeatureFlagMacroClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
    ],
    targets: [
        .macro(
            name: "FeatureFlagMacroPlugin",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "FeatureFlagMacro", dependencies: ["FeatureFlagMacroPlugin"]),
        .executableTarget(name: "FeatureFlagMacroClient", dependencies: ["FeatureFlagMacro"]),
        .testTarget(
            name: "FeatureFlagMacroTests",
            dependencies: [
                "FeatureFlagMacroPlugin",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
