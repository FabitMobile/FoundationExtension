import Foundation
import UserNotifications

public struct PushNotification {
    public var identifier: String
    public var userInfo: [AnyHashable: Any]

    public init(identifier: String,
                userInfo: [AnyHashable: Any]) {
        self.identifier = identifier
        self.userInfo = userInfo
    }
}
