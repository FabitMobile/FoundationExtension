import Foundation

public protocol Mutable {}

extension Mutable {
    public func mutate(_ mutation: (inout Self) -> Void) -> Self {
        var result = self
        mutation(&result)
        return result
    }
}
