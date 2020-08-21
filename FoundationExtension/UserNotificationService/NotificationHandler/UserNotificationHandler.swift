import PromiseKit
import UIKit
import UserNotifications

public class HandleUserNotificationError: Error {
    public init() {}
}

public protocol UserNotificationHandler {
    func handle(pushNotification: PushNotification, applicationState: UIApplication.State) -> Promise<Void>

    @available(iOS 10.0, *)
    func callCompletions(for systemNotification: UNNotification, completions: PushNotificationsCompletions?)
}

@available(iOS 10.0, *)
extension Collection where Iterator.Element == UserNotificationHandler {
    func handle(pushNotification: PushNotification,
                from systemNotification: UNNotification,
                applicationState: UIApplication.State,
                completions: PushNotificationsCompletions?) {
        guard let firstElement = first else { return }
        firstElement.handle(pushNotification: pushNotification, applicationState: applicationState)
            .done { _ in
                firstElement.callCompletions(for: systemNotification,
                                             completions: completions)
            }
            .recover { _ in
                self.dropFirst().handle(pushNotification: pushNotification,
                                        from: systemNotification,
                                        applicationState: applicationState,
                                        completions: completions)
            }
    }
}

@available(iOS, deprecated: 10.0)
extension Collection where Iterator.Element == UserNotificationHandler {
    func handle(pushNotification: PushNotification, applicationState: UIApplication.State) {
        guard let firstElement = first else { return }
        firstElement.handle(pushNotification: pushNotification,
                            applicationState: applicationState)
            .recover { _ in
                self.dropFirst().handle(pushNotification: pushNotification,
                                        applicationState: applicationState)
            }
    }
}
