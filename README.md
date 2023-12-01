# Differentiable Swift Examples

Differentiable Swift is an experimental language feature for the [Swift language](https://www.swift.org) that is currently
in the [pitch phase](https://forums.swift.org/t/differentiable-programming-for-gradient-based-machine-learning/42147) of
the Swift Evolution process. The goal of this feature is to provide first-class language-integrated support for 
differentiable programming, making Swift the first general-purpose, statically-typed programming language to have automatic
differentiation built in. Originally developed as part of the
[Swift for TensorFlow](https://www.tensorflow.org/swift/guide/overview) project, it is currently being worked on by teams
at [PassiveLogic](https://passivelogic.com) and elsewhere.

Differentiable Swift is purely a language feature, and isn't tied to any specific machine learning framework or platform.
It provides a means of building such frameworks in Swift, and works wherever Swift does: from Linux to macOS to
[WebAssembly](https://swiftwasm.org).

The goal of this repository is to provide examples and documentation for differentiable Swift, to illustrate how it can be
used and to show the power of automatic differentiation in various applications. We hope to grow this over time with new
examples and documentation, and welcome contributions to that end.

## Getting started

Differentiable Swift is present as an experimental feature in modern Swift toolchains. Due to the rapid speed at which it
is evolving, for best results we recommend using a Swift toolchain downloaded [from Swift.org](https://www.swift.org/download/)
from either the Swift 5.9 development snapshots or the nightly development snapshots. The latter will more closely track
the latest additions and fixes being upstreamed, but may be slightly less stable overall.

It is possible to use differentiable Swift with the default Swift toolchains that ship inside Xcode, however only the
compiler additions are present in those toolchains. The standard library support needed to use the `_Differentiation` module
is not provided in those toolchains and needs to be added after the fact. One example of how to do this can be found
in [this project](https://github.com/philipturner/differentiation).

No special compiler flags are needed to activate differentiable Swift, but you do need to place the following

```swift
import _Differentiation
```

in any file where differentiation will be used. The compiler will warn you about this if you do forget to add the above
and try to use any differentiable Swift capabilities.

## Examples

The following examples are present in the repository, and can be built and run via

```bash
swift run [example]
```

- [BasicDifferentiation](Sources/BasicDifferentiation/main.swift): A very simple example of using automatic differentation with a few different functions and types.
- [CustomDerivatives](Sources/CustomDerivatives/main.swift): Differentiable Swift lets you register custom derivatives for functions, and this shows how to do so.
- [BasicGradientDescent](Sources/BasicGradientDescent/main.swift): How to perform gradient descent optimization in Swift.


## Benchmarks

A motivating benchmark of a building thermal model, optimized via gradient descent, is implemented
in several languages and frameworks to compare against differentiable Swift in the [Benchmarks](Benchmarks/) directory.

## Differentiable Swift resources

If you want to learn more about differentiable Swift, there are a variety of resources out there. The API has changed over time,
so some older documentation may provide great background on the feature but not fully reflect code as it is written today.

- [Differentiable programming for gradient-based machine learning](https://forums.swift.org/t/differentiable-programming-for-gradient-based-machine-learning/42147)
- The Intro to Differentiable Swift series:
  - [Part 0: Why Automatic Differentiation is Awesome](https://medium.com/passivelogic/intro-to-differentiable-swift-part-0-why-automatic-differentiation-is-awesome-a522128ca9e3)
  - [Part 1: Gradient Descent](https://medium.com/passivelogic/intro-to-differentiable-swift-part-1-gradient-descent-181a06aaa596)
  - [Part 2: Differentiable Swift](https://medium.com/passivelogic/intro-to-differentiable-swift-part-2-differentiable-swift-25a99b97087f)
  - [Part 3: Differentiable API Introduction](https://medium.com/passivelogic/intro-to-differentiable-swift-part-3-differentiable-api-introduction-2d8d747e0ac8)
  - [Part 4: Differentiable Swift API Details](https://medium.com/passivelogic/intro-to-differentiable-swift-part-4-differentiable-swift-api-details-b6368c2dae5)
- [Differentiable Programming Manifesto](https://github.com/apple/swift/blob/main/docs/DifferentiableProgramming.md) (note: slightly out of date)
- The Swift for TensorFlow project explored the use of differentiable Swift paired with machine learning frameworks:
  - [Overview of Swift for TensorFlow](https://www.tensorflow.org/swift/guide/overview)
  - [Main Swift for TensorFlow GitHub repository](https://github.com/tensorflow/swift)
  - [Swift for TensorFlow machine learning APIs](https://github.com/tensorflow/swift-apis)
  - [Machine learning models and libraries](https://github.com/tensorflow/swift-models)
 
