// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "DifferentiableSwiftExamples",
    products: [
        .executable(name: "BasicDifferentiation", targets: ["BasicDifferentiation"]),
        .executable(name: "BasicGradientDescent", targets: ["BasicGradientDescent"]),
        .executable(name: "CustomDerivatives", targets: ["CustomDerivatives"]),
        .library(name: "DifferentiableSwiftExamples", targets: ["DifferentiableSwiftExamples"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0"),
    ],
    targets: [
        .executableTarget(name: "BasicDifferentiation"),
        .executableTarget(name: "BasicGradientDescent"),
        .executableTarget(name: "CustomDerivatives"),
        .target(name: "DifferentiableSwiftExamples", path: "Sources/DifferentiableSwiftExamplesDocumentation"),
	]
)
