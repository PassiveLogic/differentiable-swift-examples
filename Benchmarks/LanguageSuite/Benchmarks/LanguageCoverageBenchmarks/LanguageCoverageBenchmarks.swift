import Benchmark
import Foundation
import _Differentiation

enum CustomMeasurement {
    static let forward = BenchmarkMetric.custom("run forward (ns)", polarity: .prefersSmaller, useScalingFactor: true)
    static let reverse = BenchmarkMetric.custom("run reverse (ns)", polarity: .prefersSmaller, useScalingFactor: true)
    static let ratio = BenchmarkMetric.custom("ratio", polarity: .prefersSmaller, useScalingFactor: true)
}

extension Benchmark {
    @discardableResult
    convenience init?(_ name: String, forward: @escaping (Benchmark) -> (), reverse: @escaping (Benchmark) -> ()) {
        self.init(name, configuration: .init(metrics: [CustomMeasurement.forward, CustomMeasurement.reverse, CustomMeasurement.ratio])) { benchmark in
            let startForward = BenchmarkClock.now
            forward(benchmark)
            let endForward = BenchmarkClock.now
            let startReverse = BenchmarkClock.now
            reverse(benchmark)
            let endReverse = BenchmarkClock.now
            
            let forward = Int((endForward - startForward).nanoseconds())
            let reverse = Int((endReverse - startReverse).nanoseconds())
            
            benchmark.measurement(CustomMeasurement.forward, forward)
            benchmark.measurement(CustomMeasurement.reverse, reverse)
            benchmark.measurement(CustomMeasurement.ratio, reverse / forward)
        }
    }
}

let benchmarks = {
    Benchmark.defaultConfiguration = .init(
        warmupIterations: 1,
        scalingFactor: .kilo
    )
    
    // Simple functions.
    
    Benchmark(
        "one operation",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(oneOperation(a: 2))
            }
        },
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: oneOperation))
            }
        }
    )
    Benchmark(
        "sixteen operations",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(sixteenOperations(a: 2))
            }
        },
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: sixteenOperations))
            }
        }
    )
    Benchmark(
        "two composed operations",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(twoComposedOperations(a: 2))
            }
        },
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: twoComposedOperations))
            }
        }
    )
    Benchmark(
        "sixteen composed operations",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(sixteenComposedOperations(a: 2))
            }
        },
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: sixteenComposedOperations))
            }
        }
    )
    
    // Functions with loops.
    
    Benchmark(
        "one operation looped (small)",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(oneOperationLoopedSmall(a: 2))
            }
        }, 
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: oneOperationLoopedSmall))
            }
        }
    )
    Benchmark(
        "four operations looped (small)",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(fourOperationsLoopedSmall(a: 2))
            }
        }, 
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: fourOperationsLoopedSmall))
            }
        }
    )
    Benchmark(
        "sixteen operations looped (small)",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(sixteenOperationsLoopedSmall(a: 2))
            }
        }, 
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: sixteenOperationsLoopedSmall))
            }
        }
    )
    Benchmark(
        "one operation looped",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(oneOperationLooped(a: 2))
            }
        }, 
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: oneOperationLooped))
            }
        }
    )
    Benchmark(
        "two operations looped",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(twoOperationsLooped(a: 2))
            }
        }, 
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: twoOperationsLooped))
            }
        }
    )
    Benchmark(
        "four operations looped",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(fourOperationsLooped(a: 2))
            }
        }, 
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: fourOperationsLooped))
            }
        }
    )
    Benchmark(
        "eight operations looped",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(eightOperationsLooped(a: 2))
            }
        }, 
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: eightOperationsLooped))
            }
        }
    )
    Benchmark(
        "sixteen operations looped",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(sixteenOperationsLooped(a: 2))
            }
        }, 
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: sixteenOperationsLooped))
            }
        }
    )
    Benchmark(
        "two composed operations looped",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(twoComposedOperationsLooped(a: 2))
            }
        }, 
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: twoComposedOperationsLooped))
            }
        }
    )
    Benchmark(
        "sixteen composed operations looped",
        forward: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(sixteenComposedOperationsLooped(a: 2))
            }
        }, 
        reverse: { benchmark in
            for _ in benchmark.scaledIterations {
                blackHole(gradient(at: 2, of: sixteenComposedOperationsLooped))
            }
        }
    )
}
