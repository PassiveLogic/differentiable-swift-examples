# Sharp edges in differentiable Swift

This is an overview of some of the currently missing capabilities in differentiable Swift you may encounter when working with the feature. Inspired by the original [Swift for TensorFlow notebook](https://www.tensorflow.org/swift/tutorials/Swift_autodiff_sharp_edges), we intend for this to be an up-to-date and comprehensive list of common issues you may encounter when working with differentiable Swift.


## Overview

- Forward mode differentiation (`@differentiable(forward)` JVPs) is only partially implemented.
- Differentiation through `_modify` subscript accessors (like array subscript setters) isn't supported yet.
- Differentiation through `@_alwaysEmitIntoClient` tagged functions isn’t yet supported. The most common cases of these are in SIMD functions, like `.sum()`.
- `map()` and `reduce()` cannot be differentiated through directly, instead there are special functions for `differentiableMap()` and `differentiableReduce()`.
- No support yet in the standard library for Dictionary differentiation.
- `for..in` loops currently require using `withoutDerivative(at:)` on the collection you're looping over.

### Examples
Coming Soon
