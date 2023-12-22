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
    let gradient = pullback(-0.1)
    model.move(by: gradient)
}

let value1 = model(1.0, 0.0)
print("Value at (1.0, 0.0): \(value1)")
// Value at (1.0, 0.0): 0.1
let value2 = model(1.0, 1.0)
print("Value at (1.0, 1.0): \(value2)")
// Value at (1.0, 1.0): 0.9
