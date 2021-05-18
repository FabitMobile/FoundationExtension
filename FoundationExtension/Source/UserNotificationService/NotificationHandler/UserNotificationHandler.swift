import UIKit
import UserNotifications
import RxSwift

public class HandleUserNotificationError: Error {
    public init() {}
}

public protocol UserNotificationHandler {
    func handle<UserInfo:Codable>(pushNotification: PushNotification<UserInfo>, applicationState: UIApplication.State) -> Single<Void>
    
    func callCompletions(for systemNotification: UNNotification, completions: PushNotificationsCompletions?)
    
    func handle(from systemNotification: UNNotification,
                applicationState: UIApplication.State,
                completions: PushNotificationsCompletions?)
}

//extension UserNotificationHandler {
open class BaseUserNotificationHandler<UserInfo: Codable>: UserNotificationHandler {
    
    public func handle<UserInfo:Codable>(pushNotification: PushNotification<UserInfo>,
                       applicationState: UIApplication.State) -> Single<Void> {
        fatalError("Not implemented")
    }
    
    public init() {}
    
    public func handle(from systemNotification: UNNotification,
                applicationState: UIApplication.State,
                completions: PushNotificationsCompletions?) where UserInfo: Codable {
        var systemUserInfo = systemNotification.request.content.userInfo
        systemUserInfo["body"] = systemNotification.request.content.body
        
        if let data = try? JSONSerialization.data(withJSONObject: systemUserInfo, options: .prettyPrinted),
           let userInfo = try? JSONDecoder().decode(UserInfo.self, from: data) {
            
            let pushNotification = PushNotification<UserInfo>(identifier: systemNotification.request.identifier,
                                                              userInfo: userInfo)
            handle(pushNotification: pushNotification, applicationState: applicationState)
                .map { [weak self] _ in
                    guard let __self = self else { throw NilSelfError() }
                    __self.callCompletions(for: systemNotification,
                                           completions: completions)
                }
        }
    }
    
    public func callCompletions(for systemNotification: UNNotification, completions: PushNotificationsCompletions?) {
        completions?.forgroundCompletionHandler?(.badge)
        completions?.backgroundCompletionHandler?()
    }
}
