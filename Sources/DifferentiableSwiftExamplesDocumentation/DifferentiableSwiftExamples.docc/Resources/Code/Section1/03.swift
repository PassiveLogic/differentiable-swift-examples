import _Differentiation

@differentiable(reverse)
func squared(_ input: Double) -> Double {
    input * input
}
