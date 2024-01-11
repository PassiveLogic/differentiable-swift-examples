# Sharp edges in differentiable Swift

An overview of some of the currently missing capabilities in differentiable Swift.

## Overview

This is an overview of some of the currently missing capabilities in differentiable Swift you may encounter when working with the feature. Inspired by the original [Swift for TensorFlow notebook](https://www.tensorflow.org/swift/tutorials/Swift_autodiff_sharp_edges), we intend for this to be an up-to-date and comprehensive list of common issues you may encounter when working with differentiable Swift.

- <doc:SharpEdgesInDifferentiableSwift#Loops>
- <doc:SharpEdgesInDifferentiableSwift#Map-and-Reduce>
- <doc:SharpEdgesInDifferentiableSwift#Array-subscript-setters>
- <doc:SharpEdgesInDifferentiableSwift#Floating-point-type-conversions>
- <doc:SharpEdgesInDifferentiableSwift#Keypath-subscripting>
- <doc:SharpEdgesInDifferentiableSwift#Other>

### Loops
Loops over collections of `Differentiable` objects unfortunately aren't differentiable yet. So as of yet the compiler cannot determine the derivative of the following function: 
```swift
@differentiable(reverse)
func loopy(values: [Double]) -> Double {
    var total = 0.0
    for value in values {
        total += value
    }
    return total
}
```

Luckily there are ways around this! Reading a value at a certain index is differentiable. So instead of looping over the values directly, as a workaround we can loop over the indices as seen in the example below. The one thing to note here is that we access the indices by wrapping them in `withoutDerivative(at:)` This tells the compiler that we don't want to take the derivative of the property that returns all indices (which is not differentiable since they're discrete values.)
```swift
@differentiable(reverse)
func loopy(values: [Double]) -> Double {
    var total = 0.0
    for index in withoutDerivative(at: values.indices) {
        total += values[index]
    }
    return total
}
```

This will return the correct gradient for this function given a certain input:
```swift
let (value, gradient) = valueWithGradient(at: [1.0, 2.0, 3.0], of: loopy)
// value = 6.0
// gradient = [1.0, 1.0, 1.0] ie. a change in any of the values in the array will effect the output of the function equally. 
```

### Map and Reduce
The `map` and `reduce` methods do not currently support closures marked with `@differentiable` but there's special differentiable versions of these that work exactly like you're used to:
```swift
let a = [1.0, 2.0, 3.0]
let aPlusOne = a.differentiableMap { $0 + 1.0 } // [2.0, 3.0, 4.0]
let aSum = a.differentiableReduce { 0, + } // 6.0
```

### Array subscript setters
Currently the subcript setters on arrays (`array[0] = 1.0`) are not differentiable. Under the hood this is due to `_modify` subscript accessors not supporting differentiability yet. (Work is ongoing, and this feature should land in Swift soon.)
We can currently get around this however by extending the `Array` type with a mutating `update(at:with:)` function
```swift
extension Array where Element: Differentiable {
    @differentiable(where Element: Differentiable) // TODO: This where clause seems redundant?
    mutating func update(at index: Int, with newValue: Element) {
        self[index] = newValue
    }

    @derivative(of: update)
    mutating func vjpUpdate(at index: Int, with newValue: Element)
      -> (value: Void, pullback: (inout TangentVector) -> (Element.TangentVector))
    {
        self.updated(at: index, with: newValue)
        return ((), { v in
            let dElement = v[index]
            v.base[index] = .zero
            return dElement
        })
    }
}
```
The first function wraps the subscript setter and marks it as differentiable. The second function defines a custom vjp (vector Jacobian product) telling the compiler what the derivative of this wrapped function is. 

Considering:
```swift
var b: [Double] = [1.0, 2.0, 3.0]
```
Then instead of writing (which unfortunately is not differentiable (Coming soon!)): 
```swift
b[0] = 17.0
```
We can now write:
```swift
b.update(at: 0, with: 17.0)
```

### Floating point type conversions

If you're converting between `FloatingPointNumber`s types such as `Float` and `Double` be aware that their constructors currently aren't differentiable. This can be remedied by using a permutation of the following extension on the floating types you need:
```swift
extension Float {
    @usableFromInline
    @derivative(of: init(_:))
    static func vjpInit(_ a: Double) -> (value: Float, pullback: (Float) -> Double) {
        func pullback(_ v: Float) -> Double {
            return Double(v)
        }
        return (value: Float(a), pullback: pullback)
    }
}
```
This allows the following differentiable code to now compile:
```swift
@differentiable(reverse)
func convertToFloat(value: Double) -> Float {
    Float(value)
}
```
Hopefully this will be part of the Swift standard library in the near future!


### Keypath subscripting
`KeyPath` subscripting (get or set) doesn't work out of the box, but once again there's a workaround to get similar behaviour:
```swift
extension Differentiable {
    //-----------------------------------------------------------
    // a read that's O(n) on the backwards pass (because of zeroTangentVector materialization)
    @inlinable
    @differentiable(where Self == TangentVector, T: Differentiable, T == T.TangentVector)
    public func read<T: Differentiable>(at member: WritableKeyPath<Self, T>) -> T{
        return self[keyPath: member]
    }

    @inlinable
    @derivative(of: read)
    public func vjpRead<T: Differentiable>(at member: WritableKeyPath<Self, T>) -> (value: T, pullback: (T.TangentVector) -> Self.TangentVector)
    where Self == TangentVector, T == T.TangentVector
    {
        return (value: self[keyPath: member], pullback:{ downstream in
            var zeroes = self.zeroTangentVector
            zeroes[keyPath: member] = downstream
            return zeroes
        })
    }
}
```

### Other

- Forward mode differentiation (`@differentiable(forward)` JVPs) is only partially implemented.
- Differentiation through `@_alwaysEmitIntoClient` tagged functions isn’t yet supported. The most common cases of these are in SIMD functions, like `.sum()`.
- No support yet in the standard library for Dictionary differentiation.
