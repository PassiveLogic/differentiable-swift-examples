# Using differentiable Swift
Introduces differentiable Swift and how to use it to define differentiable functions and types.

## Overview

Differentiable Swift integrates first-class support for automatic differentiation right into the Swift language.
This means that the compiler can generate derivatives of arbitrary Swift code, and the type system can identify and provide clear messages for many common programming errors around differentiability.

Differentiable functions are a key enabler of the extremely powerful technique of gradient descent optimization, which powers much of deep learning, and are useful in many other applications.

As an experimental feature, activation of differentiable Swift is gated behind the following import statement:

```swift
import _Differentiation
```

which must be present in any Swift file taking advantage of differentiation.


### Differentiable functions

You can mark a function as being differentiable if it has at least one differentiable parameter and
differentiable result. The `@differentiable` annotation is used to mark the function, and the
`reverse` specifier further clarifies that we want to use reverse-mode differentiation.

```swift
@differentiable(reverse)
func squared(_ x: Float) -> Float {
    return x * x
}
```

In addition to letting the compiler define derivatives for Swift functions, you can register custom
derivatives for any differentiable function. This is necessary for non-Swift functions or ones that
reside in external modules you don't control, if you want these functions to be differentiable. For
example, registering a derivative for the above `squared()` function might look like the following:

```swift
@derivative(of: squared)
func vjpSquared(_ input: Double) -> (
    value: Double,
    pullback: (Double) -> Double
) {
    let output = squared(value)
    func pullback(_ tangentVector: Double) -> Double {
        return tangentVector * 2 * value
    }
    return (value: output, pullback: pullback)
}
```

### Differentiable types

To declare a type as being differentiable, it needs to conform to the `Differentiable` protocol.
Generally, types are differentiable if they are continuous or if all of their properties are
continuous and `Differentiable`. Differentiable types can have non-Differentiable properties, if
those properties are annotated with `@noDerivative`. For example, the following is a custom struct
that is `Differentiable`:

``` swift
struct MyValue: Differentiable {
    var x: Float
    var y: Double
    @noDerivative
    let isTracked: Bool
}
```


### Obtaining and working with gradients and pullbacks

To activate the differentiation machinery, there are some special built-in functions in the
Differentiation module within the Swift standard library that can give you the value from the
forward pass through a differentiable function as well as the backward pass.

For functions with scalar outputs, `valueWithGradient(at:of:)` will return both the value and the
calculated gradient at a given input value:

```swift
let (value, gradient) = valueWithGradient(at: 3.0, of: square)
print("The value is \(value), and the gradient is \(gradient)")
// Prints a value of 9.0 and a gradient of 6.0.
```
