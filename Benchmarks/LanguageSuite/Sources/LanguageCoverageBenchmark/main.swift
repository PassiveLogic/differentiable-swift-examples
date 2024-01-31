import Benchmark
import Foundation
import _Differentiation

// Helper to prevent operations from being optimized away.

var blackHole: Any? = nil

@inline(never)
public func consume<T>(_ x: T) {
    blackHole = x
}

// Simple functions.

benchmark("Forward: one operation") {
    consume(oneOperation(a: 2))
}
benchmark("Reverse: one operation") {
    consume(gradient(at: 2, of: oneOperation))
}
benchmark("Forward: sixteen operations") {
    consume(sixteenOperations(a: 2))
}
benchmark("Reverse: sixteen operations") {
    consume(gradient(at: 2, of: sixteenOperations))
}
benchmark("Forward: two composed operations") {
    consume(twoComposedOperations(a: 2))
}
benchmark("Reverse: two composed operations") {
    consume(gradient(at: 2, of: twoComposedOperations))
}
benchmark("Forward: sixteen composed operations") {
    consume(sixteenComposedOperations(a: 2))
}
benchmark("Reverse: sixteen composed operations") {
    consume(gradient(at: 2, of: sixteenComposedOperations))
}

// Functions with loops.

benchmark("Forward: one operation looped (small)") {
    consume(oneOperationLoopedSmall(a: 2))
}
benchmark("Reverse: one operation looped (small)") {
    consume(gradient(at: 2, of: oneOperationLoopedSmall))
}
benchmark("Forward: four operations looped (small)") {
    consume(fourOperationsLoopedSmall(a: 2))
}
benchmark("Reverse: four operations looped (small)") {
    consume(gradient(at: 2, of: fourOperationsLoopedSmall))
}
benchmark("Forward: sixteen operations looped (small)") {
    consume(sixteenOperationsLoopedSmall(a: 2))
}
benchmark("Reverse: sixteen operations looped (small)") {
    consume(gradient(at: 2, of: sixteenOperationsLoopedSmall))
}
benchmark("Forward: one operation looped") {
    consume(oneOperationLooped(a: 2))
}
benchmark("Reverse: one operation looped") {
    consume(gradient(at: 2, of: oneOperationLooped))
}
benchmark("Forward: two operations looped") {
    consume(twoOperationsLooped(a: 2))
}
benchmark("Reverse: two operations looped") {
    consume(gradient(at: 2, of: twoOperationsLooped))
}
benchmark("Forward: four operations looped") {
    consume(fourOperationsLooped(a: 2))
}
benchmark("Reverse: four operations looped") {
    consume(gradient(at: 2, of: fourOperationsLooped))
}
benchmark("Forward: eight operations looped") {
    consume(eightOperationsLooped(a: 2))
}
benchmark("Reverse: eight operations looped") {
    consume(gradient(at: 2, of: eightOperationsLooped))
}
benchmark("Forward: sixteen operations looped") {
    consume(sixteenOperationsLooped(a: 2))
}
benchmark("Reverse: sixteen operations looped") {
    consume(gradient(at: 2, of: sixteenOperationsLooped))
}
benchmark("Forward: two composed operations looped") {
    consume(twoComposedOperationsLooped(a: 2))
}
benchmark("Reverse: two composed operations looped") {
    consume(gradient(at: 2, of: twoComposedOperationsLooped))
}
benchmark("Forward: sixteen composed operations looped") {
    consume(sixteenComposedOperationsLooped(a: 2))
}
benchmark("Reverse: sixteen composed operations looped") {
    consume(gradient(at: 2, of: sixteenComposedOperationsLooped))
}

Benchmark.main()
