import PassKit
import UIKit
// sourcery: mirageMock
public protocol ApplePayService {
    // MARK: - properties

    var isAvailable: Bool { get }

    // MARK: - methods

    func makeTransaction(items: [ApplePayServiceItem]) -> ApplePayTransaction?
}
