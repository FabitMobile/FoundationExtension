import PromiseKit
import UIKit
import UserNotifications

@available(iOS 10.0, *)
public class UserNotificationServiceImpl: NSObject, UserNotificationService {
    var application: UIApplication
    var userNotificationCenter: UNUserNotificationCenter
    static var apnsHandler: ApnsHandler?
    var notificationHandlers: [UserNotificationHandler]

    public init(application: UIApplication,
                userNotificationCenter: UNUserNotificationCenter,
                apnsHandler: ApnsHandler?,
                notificationHandlers: [UserNotificationHandler]) {
        self.application = application
        self.userNotificationCenter = userNotificationCenter
        UserNotificationServiceImpl.apnsHandler = apnsHandler
        self.notificationHandlers = notificationHandlers
        super.init()

        // swiftlint:disable force_unwrapping
        self.application.delegate?.transferControl(from: application.delegate!, to: self)
    }

    open func permissionsStatus(_ completion: @escaping ((NotificationPermissions?) -> Void)) {
        userNotificationCenter.getNotificationSettings(completionHandler: { settings in
            let authorizationStatus = NotificationsPermissionStatus(settings.authorizationStatus)
            let lockScreenStatus = NotificationsPermissionStatus(settings.lockScreenSetting)
            let notificationCenterStatus = NotificationsPermissionStatus(settings.notificationCenterSetting)
            let badgeStatus = NotificationsPermissionStatus(settings.badgeSetting)

            let permissions = NotificationPermissions(authorizationStatus: authorizationStatus,
                                                      lockScreenStatus: lockScreenStatus,
                                                      notificationCenterStatus: notificationCenterStatus,
                                                      badgeStatus: badgeStatus)
            completion(permissions)
        })
    }

    // MARK: - register

    open func registerForNotifications(_ types: [UserNotificationType]) {
        let needsRemote = types.contains(.remote)

        userNotificationCenter.delegate = self

        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        userNotificationCenter.requestAuthorization(options: options) { _, error in
            if let error = error {
                print(error)
            } else if needsRemote {
                DispatchQueue.main.async { [weak self] in
                    guard let __self = self else { return }
                    __self.application.registerForRemoteNotifications()
                }
            }
        }
    }

    // MARK: - schedule

    open func schedule(identifier: String,
                       date: Date,
                       body: String,
                       userInfo: [AnyHashable: Any]?) {
        schedule(identifier: identifier,
                 date: date,
                 title: nil,
                 subtitle: nil,
                 body: body,
                 userInfo: userInfo)
    }

    open func schedule(identifier: String,
                       date: Date,
                       title: String?,
                       subtitle: String?,
                       body: String,
                       userInfo: [AnyHashable: Any]?) {
        let content = UNMutableNotificationContent()

        if let title = title {
            content.title = title
        }

        if let subtitle = subtitle {
            content.subtitle = subtitle
        }

        content.body = body
        content.userInfo = userInfo ?? [:]
        content.sound = UNNotificationSound.default

        var timeDiff = date.timeIntervalSinceNow
        if timeDiff <= 0 { timeDiff = 0.1 }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeDiff, repeats: false)

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        userNotificationCenter.add(request, withCompletionHandler: { error in
            if let error = error {
                print("failed to add notification: \(error)")
            }
        })
    }

    open func scheduledNotifications(_ completion: @escaping ([String]) -> Void) {
        userNotificationCenter.getPendingNotificationRequests { requests in
            completion(requests.map { $0.identifier })
        }
    }

    // MARK: - cancel

    open func cancel(identifiers: [String]) {
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    open func cancel(identifier: String) {
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    open func cancellAll() {
        userNotificationCenter.removeAllPendingNotificationRequests()
    }

    @objc
    func userNotificationService(_ application: UIApplication,
                                 didFailToRegisterForRemoteNotificationsWithError error: Error) {
        UserNotificationServiceImpl.apnsHandler?.registerForRemoteNotifications(failWith: error)
    }

    @objc
    func userNotificationService(_ application: UIApplication,
                                 didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        UserNotificationServiceImpl.apnsHandler?.registerForRemoteNotifications(completeWithDeviceToken: deviceToken)
    }
}

@available(iOS 10.0, *)
extension UserNotificationServiceImpl: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        let notification = response.notification
        var userInfo = notification.request.content.userInfo
        userInfo["body"] = notification.request.content.body
        let pushNotification = PushNotification(identifier: notification.request.identifier,
                                                userInfo: userInfo)
        let completitions = PushNotificationsCompletions(forgroundCompletionHandler: nil,
                                                         backgroundCompletionHandler: completionHandler)
        notificationHandlers.handle(pushNotification: pushNotification,
                                    from: notification,
                                    applicationState: application.applicationState,
                                    completions: completitions)
    }

    // swiftlint:disable line_length
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        var userInfo = notification.request.content.userInfo
        userInfo["body"] = notification.request.content.body
        let pushNotification = PushNotification(identifier: notification.request.identifier,
                                                userInfo: userInfo)
        notificationHandlers.handle(pushNotification: pushNotification,
                                    from: notification,
                                    applicationState: application.applicationState,
                                    completions: PushNotificationsCompletions(forgroundCompletionHandler: completionHandler,
                                                                              backgroundCompletionHandler: nil))
    }

    public func unregisterForRemoteNotifications() {
        DispatchQueue.main.async { [weak self] in
            guard let __self = self else { return }
            __self.application.unregisterForRemoteNotifications()
        }
    }
}
