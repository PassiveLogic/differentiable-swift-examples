# Setup

How to set up your environment and get started with differentiable Swift.

## Overview

Swift toolchains that ship with Xcode lack the `_Differentiation` module needed by differentiable Swift. In order to use differentiable Swift, you will need to install a version of the toolchain from Swift.org. There are multiple way to download, install and manage different versions of toolchains depending on your needs and/or platform. 

After a toolchain has been installed there are a few things to take into consideration in order to successfully run your differentiable Swift code.

### Installing a toolchain

Toolchains can be manually downloaded and installed from [swift.org](https://swift.org/download). If you do so you can either pick a stable release or a nightly snapshot. The nightlies will often have more features and/or performance improvements.

When working with different toolchain versions across different projects we suggest using either of the following tools to manage your toolchains:

- [swiftenv](https://github.com/kylef/swiftenv) available for macOS and Linux
- [swiftly](https://github.com/swift-server/swiftly) available for Linux (macOS support is on the roadmap)

### Compiling differentiable Swift code

Compiling differentiable Swift code on Linux is easy! There's no extra setup needed and you can simply run the following if you're working on a Swift package:
```bash
swift run
```

On macOS, when running code directly from Xcode the IDE handles all toolchain specific configuration for you.

However, when compiling differentiable Swift code on macOS at the command line we have to set the following environment variables to make sure our custom toolchain uses the right macOS SDK and Swift runtime:

```bash
export SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.sdk
```
```bash
export DYLD_LIBRARY_PATH=/Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-2023-11-20-a.xctoolchain/usr/lib/swift/macosx
```

Now everything is set up and you can simply run:
```bash
swift run
```
