import _Differentiation

func squared(_ input: Double) -> Double {
    input * input
}

@derivative(of: squared)
func vjpSquared(_ input: Double) -> (
    value: Double,
    pullback: (Double) -> Double
)
