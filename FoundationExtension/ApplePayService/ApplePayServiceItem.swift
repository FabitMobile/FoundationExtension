import Foundation
import PassKit

open class ApplePayServiceItem {
    public let title: String
    public let price: NSNumber
    public let isPending: Bool

    public init(title: String,
                price: NSNumber,
                isPending: Bool) {
        self.title = title
        self.price = price
        self.isPending = isPending
    }

    public convenience init(title: String,
                            price: NSNumber) {
        self.init(title: title,
                  price: price,
                  isPending: false)
    }

    public convenience init(title: String) {
        self.init(title: title,
                  price: NSNumber(value: 0),
                  isPending: true)
    }
}
