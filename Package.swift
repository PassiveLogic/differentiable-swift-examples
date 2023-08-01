// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "DifferentiableSwiftExamples",
    products: [
        .executable(name: "BasicDifferentiation", targets: ["BasicDifferentiation"]),
        .executable(name: "BasicGradientDescent", targets: ["BasicGradientDescent"]),
        .executable(name: "CustomDerivatives", targets: ["CustomDerivatives"])
	],     
	targets: [
        .executableTarget(name: "BasicDifferentiation", path: "BasicDifferentiation"),
        .executableTarget(name: "BasicGradientDescent", path: "BasicGradientDescent"),
        .executableTarget(name: "CustomDerivatives", path: "CustomDerivatives")
	]
)


