# Sharp edges in differentiable Swift

Since the deprecation of Swift for TensorFlow Differentiable Swift has come an even longer way in terms of usability. Here is an overview of some of the sharp edges and workaround that are sometimes needed to make your code differentiable. Inspired by the original (and since out of date) [Swift for TensorFlow article](https://www.tensorflow.org/swift/tutorials/Swift_autodiff_sharp_edges)


## Overview

- Forward mode differentiation (`@differentiable(forward)` JVPs) is half-implemented.
- Differentiation through `_modify` subscript accessors (like array subscript setters) isn't supported yet
- Differentiation through `@_alwaysEmitIntoClient` tagged functions isn’t yet supported. The most common cases of these are in SIMD functions, like .sum().
- We need to use differentiableReduce instead of differentiating through .reduce().
- No support yet in the standard library for Dictionary differentiation.
- for..in should be differentiable for collections, but currently isn’t.

### Topics
