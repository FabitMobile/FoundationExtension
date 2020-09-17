import Foundation

open class ApplePayResponse {
    public let transactionIdentifier: String
    public let paymentData: Data
    public let type: String
    public let displayName: String?
    public let network: String?

    public var token: String

    public var serializedToken: String! {
        var dictionary: [AnyHashable: Any] = [:]
        var paymentData: [AnyHashable: Any] = [:]
        do {
            guard let json = try JSONSerialization.jsonObject(with: self.paymentData, options: [])
                as? [AnyHashable: Any] else { return "" }
            paymentData = json
        } catch {
            print(#file, #line)
        }

        dictionary["paymentData"] = paymentData
        dictionary["transactionIdentifier"] = transactionIdentifier

        var paymentMethod: [AnyHashable: Any] = [:]
        paymentMethod["type"] = type

        if let displayName = displayName {
            paymentMethod["displayName"] = displayName
        }

        if let network = network {
            paymentMethod["network"] = network
        }

        dictionary["paymentMethod"] = paymentMethod

        do {
            let json = try JSONSerialization.data(withJSONObject: dictionary,
                                                  options: JSONSerialization.WritingOptions.prettyPrinted)
            return String(data: json, encoding: String.Encoding.utf8) ?? ""
        } catch {
            print(#file, #line)
        }
        return ""
    }

    public init(transactionIdentifier: String,
                paymentData: Data,
                type: String,
                displayName: String?,
                network: String?) {
        self.transactionIdentifier = transactionIdentifier
        self.paymentData = paymentData
        self.type = type
        self.displayName = displayName
        self.network = network

        token = String(data: paymentData, encoding: String.Encoding.utf8) ?? ""
    }
}
