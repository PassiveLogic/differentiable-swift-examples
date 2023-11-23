import _Differentiation

// In this example, we'll set up a very simple perceptron neural network and try to use gradient
// descent to have it mimic the functionality of an AND gate.

struct Perceptron: Differentiable {
    var weight1: Float = .random(in: -1..<1)
    var weight2: Float = .random(in: -1..<1)
    var bias: Float = 0.0

    @differentiable(reverse)
    func callAsFunction(_ x1: Float, _ x2: Float) -> Float {
        // Determine the weighted contribution from each input, plus bias.
        let output = (weight1 * x1) + (weight2 * x2) + bias
        // Apply a nonlinear activation function to the output.
        if output >= 0.0 {
            return output
        } else {
            return 0.1 * output
        }
    }
}

// This is our truth table for the expected output from various inputs.

let andGateData: [(x1: Float, x2: Float, y: Float)] = [
    (x1: 0, x2: 0, y: 0),
    (x1: 0, x2: 1, y: 0),
    (x1: 1, x2: 0, y: 0),
    (x1: 1, x2: 1, y: 1),
]

// A loss function provides a measure of how far off we are from our target behavior.

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

// Finally, we initialize the model with random weights and a zero bias:

var model = Perceptron()

// and then we perform training by finding the loss, determining a tangent vector that would
// take us in a direction that should reduce that loss, and moving our model parameters by
// that tangent vector. Over the course of training, we'll watch our loss values decrease as the
// model is trained to replicate an AND gate.

for _ in 0..<100 {
    let (loss, pullback) = valueWithPullback(at: model, of: loss)
    print("Loss: \(loss)")
    let gradient = pullback(-0.1)
    model.move(by: gradient)
}

// Let's try out our trained model on some test values:

print("Trained model results:")

let value1 = model(1.0, 0.0)

print("Value at (1.0, 0.0): \(value1)")

let value2 = model(1.0, 1.0)

print("Value at (1.0, 1.0): \(value2)")
