import _Differentiation

func square(_ x: Double) -> Double {
    x * x
}

@derivative(of: square)
func vjpSquare(_ x: Double) -> (
    value: Double,
    pullback: (Double.TangentVector) -> Double.TangentVector
) {
    return (
        value: square(x),
        pullback: { tangentVector in
            //...
        }
    )
}
