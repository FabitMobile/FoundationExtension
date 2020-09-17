import Foundation

public extension DispatchGroup {
    func enter(_ times: Int) {
        var i = times
        while i > 0 {
            enter()
            i -= 1
        }
    }
}
