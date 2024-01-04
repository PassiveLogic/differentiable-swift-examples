import _Differentiation

@differentiable(reverse)
func squared(_ input: Double) -> Double {
    input * input
}

let (value, gradient) = valueWithGradient(at: 3.0, of: square)
print("The value is \(value), and the gradient is \(gradient).")

// The value is 9.0, and the gradient is 6.0.
