import Foundation

public extension Array where Iterator.Element == Double {
    func avg() -> Double {
        reduce(0, +) / Double(count)
    }
}

public extension Array where Iterator.Element == Int {
    func avg() -> Double {
        Double(reduce(0, +)) / Double(count)
    }
}
