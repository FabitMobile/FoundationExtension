import Foundation

public extension URL {
    init(correctPath: String) {
        // swiftlint:disable force_unwrapping
        self.init(string: correctPath)!
    }
}
