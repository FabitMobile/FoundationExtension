import Foundation
import PassKit

@available(iOS, introduced: 9.0, obsoleted: 10.0)
class ApplePayTransaction9: ApplePayBaseTransaction, PKPaymentAuthorizationViewControllerDelegate {
    fileprivate var authorizationStatusBlock: ((_ status: PKPaymentAuthorizationStatus) -> Void)?

    override func start() {
        guard let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) else {
            return
        }
        controller.delegate = self
        UIApplication.shared.topViewController()?.present(controller, animated: true, completion: nil)
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

    // MARK: - PKPaymentAuthorizationViewControllerDelegate

    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true) { [weak self] in
            guard let __self = self, let onSheetDimiss = __self.onSheetDimiss else { return }
            onSheetDimiss()
        }
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didAuthorizePayment payment: PKPayment,
                                            completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        authorizationStatusBlock = completion
        handleDidAuthorizePayment(payment)
    }
}
