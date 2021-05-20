import Foundation

public protocol Mutable {}

public extension Mutable {
    func mutate(_ mutation: (inout Self) -> Void) -> Self {
        var result = self
        mutation(&result)
        return result
    }
}
