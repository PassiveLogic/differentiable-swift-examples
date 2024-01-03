import _Differentiation

struct Simple: Differentiable {
    var value1: Float
    var value2: Double

    struct TangentVector: AdditiveArithmetic, Differentiable {
        var otherValue1: Float.TangentVector
        var otherValue2: Double.TangentVector
    }

    mutating func move(by offset: TangentVector) {
        self.value1.move(by: offset.otherValue1)
        self.value2.move(by: offset.otherValue2)
    }
}
