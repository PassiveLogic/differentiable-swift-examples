import Foundation
import _Differentiation

let (value, gradient) = valueWithGradient(at: 3.0, 4.0, of: min)

// error: expression is not differentiable
