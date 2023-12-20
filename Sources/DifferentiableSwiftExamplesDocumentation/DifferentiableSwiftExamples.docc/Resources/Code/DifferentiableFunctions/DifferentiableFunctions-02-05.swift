import _Differentiation

func squared(_ input: Double) -> Double {
    input * input
}

@derivative(of: squared)
func vjpSquared(_ input: Double) -> (
    value: Double,
    pullback: (Double) -> Double
) {
    let output = squared(value)
    func pullback(_ tangentVector: Double) -> Double {
        return tangentVector * 2 * output)
    }
    return (value: output, pullback: pullback)
}
