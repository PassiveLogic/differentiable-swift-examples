import _Differentiation

func squared(_ input: Double) -> Double {
    input * input
}

@derivative(of: squared)
func vjpSquared()
