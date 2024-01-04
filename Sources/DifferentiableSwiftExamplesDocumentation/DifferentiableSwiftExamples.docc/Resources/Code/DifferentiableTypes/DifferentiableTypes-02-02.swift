import _Differentiation

struct Simple: Differentiable {
    var value1: Float
    var value2: Double

    struct TangentVector: AdditiveArithmetic, Differentiable {
        var otherValue1: Float.TangentVector
        var otherValue2: Double.TangentVector
    }
}
