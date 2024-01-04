import _Differentiation

struct Perceptron: Differentiable {
    var weight1: Float = .random(in: -1..<1)
    var weight2: Float = .random(in: -1..<1)
    var bias: Float = 0.0

    @differentiable(reverse)
    func callAsFunction(_ x1: Float, _ x2: Float) -> Float {
        let output = (weight1 * x1) + (weight2 * x2) + bias
        if output >= 0.0 {
            return output
        } else {
            return 0.1 * output
        }
    }
}

let andGateData: [(x1: Float, x2: Float, y: Float)] = [
    (x1: 0, x2: 0, y: 0),
    (x1: 0, x2: 1, y: 0),
    (x1: 1, x2: 0, y: 0),
    (x1: 1, x2: 1, y: 1),
]

@differentiable(reverse)
func loss(model: Perceptron) -> Float {
    var loss: Float = 0
    for (x1, x2, y) in andGateData {
        let prediction = model(x1, x2)
        let error = y - prediction
        loss = loss + error * error / 2
    }
    return loss
}

var model = Perceptron()

for _ in 0..<100 {
    let (loss, pullback) = valueWithPullback(at: model, of: loss)
    print("Loss: \(loss)")
}
