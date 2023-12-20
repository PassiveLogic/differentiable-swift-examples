import _Differentiation
import Foundation

let (value, gradient) = valueWithGradient(at: 3.0, 4.0, of: min)

// error: expression is not differentiable
