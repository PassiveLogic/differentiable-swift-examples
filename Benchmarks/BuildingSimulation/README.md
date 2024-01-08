# Differentiable Simulator Benchmarks

[PassiveLogic](https://passivelogic.com) is constructing autonomous systems for building control and
more, utilizing physics-based digital twins. As a motivating use case for differentiable Swift, a
simple thermal model of a building was constructed and optimized via gradient descent in several
languages and frameworks.

Differentiable Swift proves to be the best of the available solutions, and that has driven
PassiveLogic's investment in the language feature. This directory contains a representative benchmark
for a thermal model of a building implemented in differentiable Swift,
[PyTorch](https://pytorch.org), and [TensorFlow](https://www.tensorflow.org).

In this benchmark, the average time for a full forward + backward pass through the simulation is 
measured across multiple trials. The lower the time, the better.

## Current Results

The following timings were gathered using these benchmarks on an M1 Pro MacBook Pro (14", 2021):

| **Version** | **Time (ms)** | **Slowdown Compared to Swift** |
|---|:---:|:---:|
| **Swift** | 0.03 | 1X |
| **PyTorch** | 8.16 | 238X |
| **TensorFlow** | 11.0 | 322X |

## Running Benchmarks

To evaluate the benchmarks yourself, the following sections provide setup instructions for the
environments needed for each language / framework. These instructions should be valid for macOS and
Ubuntu 20.04, but may require slight modification for other platforms.

### Swift

A Swift toolchain with support for differentiation must be installed and in your current path. We 
recommend using one [downloaded from Swift.org](https://www.swift.org/download/) for your platform. 
Nightly toolchain snapshots tend to have better performance, due to new optimizations and 
architectural improvements constantly being upstreamed. More information on toolchain installation 
and management can be found [here](https://passivelogic.github.io/differentiable-swift-examples/documentation/differentiableswiftexamples/setup).

To build the benchmark, change into the `Swift` subdirectory and run the following:

When using a recent Swift.org nightly toolchain snapshot on macOS, you may need to set the following environment variables to point to the correct macOS SDK and Swift runtime:
```bash
export SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.sdk
```
```bash
export DYLD_LIBRARY_PATH=/Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-2023-11-20-a.xctoolchain/usr/lib/swift/macosx
```

Then we can compile our benchmark with the following command (both macOS and Linux)
```bash
swiftc -O main.swift -o SwiftBenchmark
```

and then run it via:
```bash
./SwiftBenchmark 
```

### PyTorch

For these benchmarks, we've used PyTorch on the CPU, running in a dedicated Python environment. If
you have such an environment, you can activate it and jump ahead to running the benchmark. To
set up such an environment, start in your home directory and type:

```bash
python3 -m venv pytorch-cpu
source pytorch-cpu/bin/activate
pip install torch torchvision
```

and then run the benchmark by going to the `PyTorch` subdirectory here and using:

```bash
python3 PyTorchSimulator.py
```

### TensorFlow

For these benchmarks, we've used TensorFlow on the CPU, running in a dedicated Python environment. If
you have such an environment, you can activate it and jump ahead to running the benchmark. To
set up such an environment, start in your home directory and type:

```bash
python3 -m venv tensorflow-cpu
source tensorflow-cpu/bin/activate
pip install tensorflow
```

and then run the benchmark by going to the `TensorFlow` subdirectory here and using:

```bash
python3 TensorFlowSimulator.py
```
