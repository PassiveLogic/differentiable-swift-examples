// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "LanguageCoverageBenchmark",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .executable(name: "LanguageCoverageBenchmark", targets: ["LanguageCoverageBenchmark"])
    ],
    dependencies: [
        .package(
            name: "Benchmark",
            url: "https://github.com/google/swift-benchmark",
            .branch("main"))
    ],
    targets: [
        .target(
            name: "LanguageCoverageBenchmark",
            dependencies: ["Benchmark"])
    ]
)
