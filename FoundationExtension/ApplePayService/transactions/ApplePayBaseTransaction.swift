import Foundation
import PassKit

class ApplePayBaseTransaction: NSObject, ApplePayTransaction {
    var paymentRequest: PKPaymentRequest

    var onResponse: ApplePayTransactionResponseBlock?

    var onSheetDimiss: ApplePaySheetDismissBlock?

    init(paymentRequest: PKPaymentRequest) {
        self.paymentRequest = paymentRequest
    }

    func start() {
        fatalError("is not implemented")
    }

    func finish(success: Bool, _ completion: ApplePaySheetDismissBlock?) {
        fatalError("is not implemented")
    }

    // MARK: - protected

    func handleDidAuthorizePayment(_ payment: PKPayment) {
        guard let onResponse = onResponse else { return }

        var type: String
        switch payment.token.paymentMethod.type {
        case .credit:
            type = "credit"

        case .debit:
            type = "debit"

        case .prepaid:
            type = "prepaid"

        case .store:
            type = "store"

        case .unknown:
            type = "unknown"
        }

        let data = ApplePayResponse(transactionIdentifier: payment.token.transactionIdentifier,
                                    paymentData: payment.token.paymentData,
                                    type: type,
                                    displayName: payment.token.paymentMethod.displayName,
                                    network: payment.token.paymentMethod.network?.rawValue)
        onResponse(data)
    }
}
