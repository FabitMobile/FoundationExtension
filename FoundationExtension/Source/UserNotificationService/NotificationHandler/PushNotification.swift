import Foundation
import UserNotifications

public struct PushNotification<UserInfo: Codable> {
    public var identifier: String
    public var userInfo: UserInfo

    public init(identifier: String,
                userInfo: UserInfo) {
        self.identifier = identifier
        self.userInfo = userInfo
    }
}
