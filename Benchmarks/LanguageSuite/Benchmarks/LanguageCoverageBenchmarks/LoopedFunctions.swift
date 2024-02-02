import _Differentiation

// Simple functions in short, constant-sized loops.

let smallLoopIterations = 8

@differentiable(reverse)
func oneOperationLoopedSmall(a: Float) -> Float {
    var a = a
    for _ in 0..<smallLoopIterations {
        a = a * 2
    }
    return a
}

@differentiable(reverse)
func fourOperationsLoopedSmall(a: Float) -> Float {
    var a = a
    for _ in 0..<smallLoopIterations {
        a = 3 / a * 2
        a = 3 / a * 2
    }
    return a
}

@differentiable(reverse)
func sixteenOperationsLoopedSmall(a: Float) -> Float {
    var a = a
    for _ in 0..<smallLoopIterations {
        a = 3 / a * 2
        a = 3 / a * 2
        a = 3 / a * 2
        a = 3 / a * 2
        a = 3 / a * 2
        a = 3 / a * 2
        a = 3 / a * 2
        a = 3 / a * 2
    }
    return a
}

// Simple functions in longer loops.

let loopIterations = 100

@differentiable(reverse)
func oneOperationLooped(a: Float) -> Float {
    var a = a
    for _ in 0..<loopIterations {
        a = a * 2
    }
    return a
}

@differentiable(reverse)
func twoOperationsLooped(a: Float) -> Float {
    var a = a
    for _ in 0..<loopIterations {
        a = 3 / a * 2
    }
    return a
}

@differentiable(reverse)
func fourOperationsLooped(a: Float) -> Float {
    var a = a
    for _ in 0..<loopIterations {
        a = 3 / a * 2
        a = 3 / a * 2
    }
    return a
}

@differentiable(reverse)
func eightOperationsLooped(a: Float) -> Float {
    var a = a
    for _ in 0..<loopIterations {
        a = 3 / a * 2
        a = 3 / a * 2
        a = 3 / a * 2
        a = 3 / a * 2
    }
    return a
}

@differentiable(reverse)
func sixteenOperationsLooped(a: Float) -> Float {
    var a = a
    for _ in 0..<loopIterations {
        a = 3 / a * 2
        a = 3 / a * 2
        a = 3 / a * 2
        a = 3 / a * 2
        a = 3 / a * 2
        a = 3 / a * 2
        a = 3 / a * 2
        a = 3 / a * 2
    }
    return a
}

// Composed functions in loops.

@differentiable(reverse)
func twoComposedOperationsLooped(a: Float) -> Float {
    var a = a
    for _ in 0..<loopIterations {
        a = twoComposedOperations(a: a)
    }
    return a
}

@differentiable(reverse)
func sixteenComposedOperationsLooped(a: Float) -> Float {
    var a = a
    for _ in 0..<loopIterations {
        a = sixteenComposedOperations(a: a)
    }
    return a
}
