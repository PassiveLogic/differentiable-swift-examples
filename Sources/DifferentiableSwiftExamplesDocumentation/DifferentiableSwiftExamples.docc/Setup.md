# Setup

How to setup your environment and get started with differentiable Swift.

## Overview

In stable Swift releases the Differentiable Swift features has been disabled. So in order to use Differentiable Swift you will need to install a development snapshot version of the toolchain. There are multiple way to download, install and manage different versions of toolchains depending on your needs and/or platform. 

After a toolchain has been installed there are a few things to take into consideration in order to successfully run your differentiable Swift code.

### Installing a toolchain

Toolchains can be manually downloaded and installed from [swift.org](https://swift.org/download). If you do so make sure to select a development snapshot and not a stable release since Differentiable Swift is dissabled on the stable branches. 

When working with different toolchain versions across different projects we suggest using either of the following tools to manage your toolchains:

- [swiftenv](https://github.com/kylef/swiftenv) available for macOS and Linux
- [swiftly](https://github.com/swift-server/swiftly) available for Linux (macOS support is on the roadmap)

### Compiling Differentiable Swift code

Compiling Differentiable Swift code on Linux is easy! There's no extra setup needed and you can simply run the following if you're working on a swift package:
```bash
swift run
```

On macOS, when running code directly from Xcode the IDE handles all toolchain specific configuration for you.

However when compiling Differentiable Swift code on macOS from terminal keep in mind that due to using a custom toolchain we have to set the following variables to make sure our custom toolchain uses the right sdk and runtime:

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
