import Foundation
import _Differentiation

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

let (value, gradient) = valueWithGradient(at: 3.0, 4.0, of: min)
print("The min() value is \(value2), and the gradient is \(gradient2).")

// The min() value is 3.0, and the gradient is (1.0, 0.0).
