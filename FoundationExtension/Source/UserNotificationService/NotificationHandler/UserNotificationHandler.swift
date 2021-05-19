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
    open func handle<UserInfo: Codable>(pushNotification: PushNotification<UserInfo>,
                                        applicationState: UIApplication.State) -> Single<Void> {
        fatalError("Not implemented")
    }

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
                .do(onSuccess: { _ in
                    completions?.forgroundCompletionHandler?(.badge)
                    completions?.backgroundCompletionHandler?()
                })
                .subscribe()
                .disposed(by: disposeBag)
        }
    }
}
