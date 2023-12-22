import _Differentiation

struct Perceptron: Differentiable {
    var weight1: Float = .random(in: -1..<1)
    var weight2: Float = .random(in: -1..<1)
    var bias: Float = 0.0
}
