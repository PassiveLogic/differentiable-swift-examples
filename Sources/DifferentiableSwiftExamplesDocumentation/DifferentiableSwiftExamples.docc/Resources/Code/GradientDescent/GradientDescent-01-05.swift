import _Differentiation

struct Perceptron: Differentiable {
    var weight1: Float = .random(in: -1..<1)
    var weight2: Float = .random(in: -1..<1)
    var bias: Float = 0.0

    @differentiable(reverse)
    func callAsFunction(_ x1: Float, _ x2: Float) -> Float {
        let output = (weight1 * x1) + (weight2 * x2) + bias
    }
}
