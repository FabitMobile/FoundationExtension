import Foundation
import PassKit

public typealias ApplePaySheetDismissBlock = () -> Void
public typealias ApplePayTransactionResponseBlock = (_ applePayResponse: ApplePayResponse) -> Void
// sourcery: mirageMock
public protocol ApplePayTransaction {
    func start()
    func finish(success: Bool, _ completion: ApplePaySheetDismissBlock?)

    var onResponse: ApplePayTransactionResponseBlock? { get set }

    var onSheetDimiss: ApplePaySheetDismissBlock? { get set }
}
