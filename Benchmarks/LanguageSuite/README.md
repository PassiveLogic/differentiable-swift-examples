# Benchmarks of Language Coverage

A primary capability of differentiable Swift is the automatic generation of reverse-mode
derivatives (pullbacks) from arbitrary Swift functions. Ideally, those generated pullbacks
would have roughly the same performance as running the original code (the forward pass).

However, Swift is a complex language and performance of the generated pullback code currently varies
based on the structure of the original functions. This benchmark suite is intended to cover a range
of representative Swift code to verify pullback performance and guide future optimizations.

## Running Benchmarks

A Swift toolchain with support for differentiation must be installed and in your current path. We 
recommend using one [downloaded from Swift.org](https://www.swift.org/download/) for your platform. 
Nightly toolchain snapshots tend to have better performance, due to new optimizations and 
architectural improvements constantly being upstreamed. More information on toolchain installation 
and management can be found [here](https://passivelogic.github.io/differentiable-swift-examples/documentation/differentiableswiftexamples/setup).

When using a recent Swift.org nightly toolchain snapshot on macOS, you may need to set the following environment variables to point to the correct macOS SDK and Swift runtime:
```bash
export SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.sdk
```
```bash
export DYLD_LIBRARY_PATH=/Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-2023-11-20-a.xctoolchain/usr/lib/swift/macosx
```

Build and run the benchmark via the following:
```bash
swift run -c release LanguageCoverageBenchmark
```
