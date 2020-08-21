import Foundation
import PassKit

@available(iOS 10.0, *)
class ApplePayTransaction10: ApplePayBaseTransaction, PKPaymentAuthorizationControllerDelegate {
    fileprivate var authorizationStatusBlock: ((_ status: PKPaymentAuthorizationStatus) -> Void)?

    override func start() {
        let controller = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        controller.delegate = self
        controller.present()
    }

    override func finish(success: Bool, _ completion: ApplePaySheetDismissBlock?) {
        guard let authorizationStatusBlock = authorizationStatusBlock else { return }
        onSheetDimiss = completion
        if success {
            authorizationStatusBlock(.success)
        } else {
            authorizationStatusBlock(.failure)
        }
        self.authorizationStatusBlock = nil
    }

    // MARK: - PKPaymentAuthorizationControllerDelegate

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss { [weak self] in
            guard let __self = self, let onSheetDimiss = __self.onSheetDimiss else { return }
            onSheetDimiss()
        }
    }

    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController,
                                        didAuthorizePayment payment: PKPayment,
                                        completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        authorizationStatusBlock = completion
        handleDidAuthorizePayment(payment)
    }
}
