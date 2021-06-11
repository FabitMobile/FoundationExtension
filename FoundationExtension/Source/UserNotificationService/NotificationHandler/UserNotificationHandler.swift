import RxSwift
import UIKit
import UserNotifications

public class HandleUserNotificationError: Error {
    public init() {}
}

public protocol UserNotificationHandler {
    func handle(from systemNotification: UNNotification,
                applicationState: UIApplication.State,
                completions: PushNotificationsCompletions?)
}

open class BaseUserNotificationHandler<UserInfo: Codable>: UserNotificationHandler {
    var disposeBag = DisposeBag()

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
                .do(onSuccess: { [weak self] _ in
                    self?.callCompletions(for: systemNotification, completions: completions)
                })
                .subscribe()
                .disposed(by: disposeBag)
        }
    }

    open func callCompletions(for systemNotification: UNNotification, completions: PushNotificationsCompletions?) {
        completions?.forgroundCompletionHandler?(.badge)
        completions?.backgroundCompletionHandler?()
    }

    open func handle(pushNotification: PushNotification<UserInfo>,
                     applicationState: UIApplication.State) -> Single<Void> {
        fatalError("Not implemented")
    }
}
