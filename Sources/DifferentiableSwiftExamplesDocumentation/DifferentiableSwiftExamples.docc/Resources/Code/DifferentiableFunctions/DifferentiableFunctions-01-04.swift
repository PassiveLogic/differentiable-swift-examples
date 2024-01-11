import _Differentiation

@differentiable(reverse)
func squared(_ input: Double) -> Double {
    input * input
}

let (value, gradient) = valueWithGradient(at: 3.0, of: squared)
