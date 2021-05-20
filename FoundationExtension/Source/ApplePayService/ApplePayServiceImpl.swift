import PassKit
import UIKit

public class ApplePayServiceImpl: ApplePayService {
    // MARK: - apple pay props

    public var merchantId: String
    public var countryCode: String
    public var currencyCode: String
    public var supportedPaymentNetworks: [PKPaymentNetwork]
    public var merchantCapabilities: PKMerchantCapability

    public init(merchantId: String,
                countryCode: String,
                currencyCode: String,
                supportedPaymentNetworks: [PKPaymentNetwork],
                merchantCapabilities: PKMerchantCapability) {
        self.merchantId = merchantId
        self.countryCode = countryCode
        self.currencyCode = currencyCode
        self.supportedPaymentNetworks = supportedPaymentNetworks
        self.merchantCapabilities = merchantCapabilities
    }

    public var isAvailable: Bool {
        PKPaymentAuthorizationViewController.canMakePayments()
    }

    public func makeTransaction(items: [ApplePayServiceItem]) -> ApplePayTransaction? {
        let summaryItems = items.map { PKPaymentSummaryItem(label: $0.title,
                                                            amount: NSDecimalNumber(value: $0.price.floatValue),
                                                            type: $0.isPending ? .pending : .final) }

        let request = PKPaymentRequest()
        request.merchantIdentifier = merchantId
        request.countryCode = countryCode
        request.currencyCode = currencyCode
        request.supportedNetworks = supportedPaymentNetworks
        request.paymentSummaryItems = summaryItems
        request.merchantCapabilities = merchantCapabilities

        if #available(iOS 11.0, *) {
            let transaction = ApplePayTransaction11(paymentRequest: request)
            return transaction

        } else if #available(iOS 10.0, *) {
            let transaction = ApplePayTransaction10(paymentRequest: request)
            return transaction
        }
        return nil
    }
}
