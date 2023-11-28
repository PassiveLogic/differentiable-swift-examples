import Foundation
import _Differentiation

// In addition to compiler-generated derivatives, you can register your own custom derivatives
// for any function to make them differentiable. This is particularly useful for functions that
// have been defined in C libraries, like basic math functions.
//
// As an example of this, the following is a custom derivative defined for the `sqrt()` function.
// `sqrt()` is a function where we don't have access to modify the original source code, so we
// need to be able to register a derivative for it so that is can be used as part of differentiable
// functions.
//
// Do do so, we define a vector-Jacobian product (VJP) (for more, see the excellent JAX
// documentation: https://jax.readthedocs.io/en/latest/notebooks/autodiff_cookbook.html#vector-jacobian-products-vjps-aka-reverse-mode-autodiff )
// The VJP takes as its input the original parameters to the main function and provides as output
// a tuple containing the value produced by the original function and a pullback function. The
// pullback has as its inputs the tangent vectors of each differentiable result and as its output
// the tangent vectors of each differentiable parameter. Note that for some types, like Double, the
// type of the tangent vector is the same as the type of the base type.

@derivative(of: sqrt)
public func sqrtVJP(_ value: Double) -> (value: Double, pullback: (Double) -> Double) {
    let output = sqrt(value)
    func pullback(_ tangentVector: Double) -> Double {
        return tangentVector / (2 * output)
    }
    return (value: output, pullback: pullback)
}

// Once a custom derivative has been defined for a function, that function is now differentiable:

let (value, gradient) = valueWithGradient(at: 9.0, of: sqrt)
print("The sqrt() value is \(value), and the gradient is \(gradient)")

// Custom derivatives are also useful in cases where the function may not be continuous across
// all values, and thus may not have a derivative at all points. We can then provide custom
// derivatives that specify an approximation that we can use, such as in the case of `min()`:
//
// For min(): "Returns: The lesser of `x` and `y`. If `x` is equal to `y`, returns `x`."
// https://github.com/apple/swift/blob/main/stdlib/public/core/Algorithm.swift#L18

@derivative(of: min)
public func minVJP<T: Comparable & Differentiable>(
    _ lhs: T,
    _ rhs: T
) -> (value: T, pullback: (T.TangentVector) -> (T.TangentVector, T.TangentVector)) {
    func pullback(_ tangentVector: T.TangentVector) -> (T.TangentVector, T.TangentVector) {
        if lhs <= rhs {
            return (tangentVector, .zero)
        } else {
            return (.zero, tangentVector)
        }
    }
    return (value: min(lhs, rhs), pullback: pullback)
}

let (value2, gradient2) = valueWithGradient(at: 3.0, 4.0, of: min)
print("The min() value is \(value2), and the gradient is \(gradient2)")
