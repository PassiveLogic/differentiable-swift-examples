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

Build and run the benchmark via the following:
```bash
swift package benchmark
```

When using a recent Swift.org nightly toolchain snapshot on macOS, you may run into segfault issues when running from terminal. This is due to the executable using the system runtime instead of the toolchain provided one. 
It is also possible to run the benchmarks from Xcode ([more info here](https://swiftpackageindex.com/ordo-one/package-benchmark/1.22.1/documentation/benchmark/runningbenchmarks#Running-benchmarks-in-Xcode-and-using-Instruments-for-profiling-benchmarks)). 
Make sure Xcode is closed and run the following to open Xcode with jemalloc disabled :
```bash
open --env BENCHMARK_DISABLE_JEMALLOC=true Package.swift
```
Set the executable's scheme to release mode and run the executable by pressing `Cmd+R`.
