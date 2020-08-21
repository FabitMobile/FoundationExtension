import Foundation
import UserNotifications

@available(iOS 10.0, *)
public struct PushNotificationsCompletions {
    public typealias ForgroundCompletionHandler = (UNNotificationPresentationOptions) -> Void
    public typealias BackgroundCompletionHandler = () -> Void

    public var forgroundCompletionHandler: ForgroundCompletionHandler?
    public var backgroundCompletionHandler: BackgroundCompletionHandler?
}
