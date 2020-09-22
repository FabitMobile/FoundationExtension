import Foundation
import PassKit

@available(iOS 11.0, *)
class ApplePayTransaction11: ApplePayTransaction10 {
    fileprivate var authorizationStatusBlock: ((_ status: PKPaymentAuthorizationResult) -> Void)?

    override func finish(success: Bool, _ completion: ApplePaySheetDismissBlock?) {
        guard let authorizationStatusBlock = authorizationStatusBlock else { return }
        onSheetDimiss = completion
        let result = PKPaymentAuthorizationResult(status: success ? .success : .failure,
                                                  errors: nil)
        authorizationStatusBlock(result)
        self.authorizationStatusBlock = nil
    }

    // MARK: - PKPaymentAuthorizationControllerDelegate

    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController,
                                        didAuthorizePayment payment: PKPayment,
                                        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        authorizationStatusBlock = completion
        handleDidAuthorizePayment(payment)
    }
}
