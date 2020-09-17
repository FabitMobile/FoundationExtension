import Foundation

public class Atomic<T> {
    private let semaphore = DispatchSemaphore(value: 1)
    private var _value: T

    public var value: T {
        get {
            wait()
            let result = _value
            defer {
                signal()
            }
            return result
        }

        set(value) {
            wait()
            _value = value
            do {
                signal()
            }
        }
    }

    public func set(closure: (_ currentValue: T) -> T) {
        wait()
        _value = closure(_value)
        signal()
    }

    public func get(closure: (_ currentValue: T) -> Void) {
        wait()
        closure(_value)
        signal()
    }

    private func wait() {
        semaphore.wait()
    }

    private func signal() {
        semaphore.signal()
    }

    public init(value: T) {
        _value = value
    }
}
