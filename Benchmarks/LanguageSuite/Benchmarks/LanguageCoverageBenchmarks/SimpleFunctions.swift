import _Differentiation

// Simple differentiable functions.

@differentiable(reverse)
func oneOperation(a: Float) -> Float {
    return a * 2
}

@differentiable(reverse)
func sixteenOperations(a: Float) -> Float {
    let b = 3 / a * 2
    let c = 3 / b * 2
    let d = 3 / c * 2
    let e = 3 / d * 2
    let f = 3 / e * 2
    let g = 3 / f * 2
    let h = 3 / g * 2
    return 3 / h * 2
}

// Simple function composition.

@differentiable(reverse)
func oneOperationHelper(a: Float) -> Float {
    return 3 / a
}

@differentiable(reverse)
func twoComposedOperations(a: Float) -> Float {
    oneOperationHelper(a: oneOperation(a: a))
}

@differentiable(reverse)
func sixteenComposedOperations(a: Float) -> Float {
    let b = oneOperation(a: a)
    let c = oneOperationHelper(a: b)
    let d = oneOperation(a: c)
    let e = oneOperationHelper(a: d)
    let f = oneOperation(a: e)
    let g = oneOperationHelper(a: f)
    let h = oneOperation(a: g)
    let i = oneOperationHelper(a: h)
    let b2 = oneOperation(a: i)
    let c2 = oneOperationHelper(a: b2)
    let d2 = oneOperation(a: c2)
    let e2 = oneOperationHelper(a: d2)
    let f2 = oneOperation(a: e2)
    let g2 = oneOperationHelper(a: f2)
    let h2 = oneOperation(a: g2)
    let i2 = oneOperationHelper(a: h2)
    return i2
}
