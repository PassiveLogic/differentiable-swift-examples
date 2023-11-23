// First, we need to enable differentiable Swift via a special import:

import _Differentiation

// You can mark a function as being differentiable if it has at least one differentiable
// parameter and differentiable result. The `@differentiable` annotation is used to mark the
// function, and the `reverse` specifier further clarifies that we want to use reverse-mode
// differentiation. In the initial implementation of differentiable Swift, only reverse-mode
// differentiation is currently fully functional.

@differentiable(reverse)
func square(_ x: Float) -> Float {
    return x * x
}

// Note that an inout value takes the place of both parameter and result, and a mutating function
// implicitly passes `self` as inout.

@differentiable(reverse)
func squared(_ x: inout Float) {
    x = x * x
}

// To declare a type as being differentiable, it needs to conform to the Differentiable protocol.
// Generally, types are differentiable if they are continuous or if all of their properties are
// continuous and Differentiable. However, Differentiable types can have non-Differentiable
// properties, if those properties are annotated with @noDerivative. Those non-Differentiable
// properties will then not participate in differentiation.
//
// Differentiable properties must also be declared as `var` and not `let`, because in order for them
// to be used in gradient descent they must be able to be moved by a tangent vector.

struct MyValue: Differentiable {
    var x: Float
    var y: Double
    @noDerivative
    let isTracked: Bool
}

// To activate the differentiation machinery, there are some special built-in functions in the
// Differentiation module within the Swift standard library that can give you the value from
// the forward pass through a differentiable function as well as the backward pass.
//
// For functions with scalar outputs, `valueWithGradient(at:of:)` will return both the value and
// the calculated gradient at a given input value:

let (value, gradient) = valueWithGradient(at: 3.0, of: square)
print("The value is \(value), and the gradient is \(gradient)")

// In the more general case, `valueWithPullback(at:of)` will provide the value and a pullback
// function for a differentiable function. For the Float-returning function above, the gradient
// is obtained by passing 1 into the pullback function:

let (value2, pullback) = valueWithPullback(at: 3.0, of: square)
print("The value is \(value2), and the pullback at 1.0 is \(pullback(1.0))")
