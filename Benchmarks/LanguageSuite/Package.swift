// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "LanguageCoverageBenchmark",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "LanguageCoverageBenchmarks", targets: ["LanguageCoverageBenchmarks"])
    ],
    dependencies: [
        .package(url: "https://github.com/ordo-one/package-benchmark", from: "1.22.1"),
    ],
    targets: [
        .executableTarget(
            name: "LanguageCoverageBenchmarks",
            dependencies: [
                .product(name: "Benchmark", package: "package-benchmark"),
            ],
            path: "Benchmarks/LanguageCoverageBenchmarks",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "package-benchmark"),
            ]
        )
    ]
)
