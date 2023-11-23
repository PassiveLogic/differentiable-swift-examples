// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "DifferentiableSwiftExamples",
    products: [
        .executable(name: "BasicDifferentiation", targets: ["BasicDifferentiation"]),
        .executable(name: "BasicGradientDescent", targets: ["BasicGradientDescent"]),
        .executable(name: "CustomDerivatives", targets: ["CustomDerivatives"])
	],    
    dependencies: [
        .package(url: "https://github.com/apple/swift-format.git", .upToNextMajor(from: "509.0.0")),
    ],
	targets: [
        .executableTarget(
            name: "BasicDifferentiation"
        ),
        .executableTarget(
            name: "BasicGradientDescent"
        ),
        .executableTarget(
            name: "CustomDerivatives"
        ),
	]
)


