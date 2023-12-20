import _Differentiation

struct MyValue: Differentiable {
    var x: Float
    var y: Double
    @noDerivative
    let isTracked: Bool
}
