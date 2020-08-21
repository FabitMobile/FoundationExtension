import UIKit
import UserNotifications

public let userInfoIdentifierKey = "userInfoIdentifierKey"

@available(iOS, deprecated: 10.0)
public class OldUserNotificationServiceImpl: NSObject, UserNotificationService {
    var application: UIApplication
    static var apnsHandler: ApnsHandler?
    static var notificationHandlers: [UserNotificationHandler]?

    public init(application: UIApplication,
                apnsHandler: ApnsHandler?,
                notificationHandlers: [UserNotificationHandler]) {
        self.application = application
        OldUserNotificationServiceImpl.apnsHandler = apnsHandler
        OldUserNotificationServiceImpl.notificationHandlers = notificationHandlers

        super.init()
        // swiftlint:disable:next force_unwrapping
        application.delegate?.transferControl(from: application.delegate!, toOldService: self)
    }

    // MARK: - permissions

    public func permissionsStatus(_ completion: @escaping ((NotificationPermissions?) -> Void)) {
        completion(nil)
    }

    // MARK: - register

    open func registerForNotifications(_ types: [UserNotificationType]) {
        let needsLocal = types.contains(.local)
        let needsRemote = types.contains(.remote)

        let options: UIUserNotificationType = [.alert, .sound, .badge]
        let settings = UIUserNotificationSettings(types: options,
                                                  categories: nil)
        if needsLocal {
            application.registerUserNotificationSettings(settings)
        }
        if needsRemote {
            application.registerForRemoteNotifications()
        }
    }

    open func unregisterForRemoteNotifications() {
        application.unregisterForRemoteNotifications()
    }

    // MARK: - schedule

    open func schedule(identifier: String,
                       date: Date,
                       body: String,
                       userInfo: [AnyHashable: Any]?) {
        var userInfoId: [AnyHashable: Any] = [userInfoIdentifierKey: identifier]
        if let userInfo = userInfo {
            userInfoId = userInfoId.reduce(userInfo) { result, element in
                var result = result
                result[element.0] = element.1
                return result
            }
        }

        let localNotification = UILocalNotification()
        localNotification.fireDate = date
        localNotification.alertBody = body
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.userInfo = userInfoId
        application.scheduleLocalNotification(localNotification)
    }

    public func schedule(identifier _: String,
                         date _: Date,
                         title _: String?,
                         subtitle _: String?,
                         body _: String,
                         userInfo _: [AnyHashable: Any]?) {
        fatalError()
    }

    public func scheduledNotifications(_ completion: @escaping ([String]) -> Void) {
        let ids = (application.scheduledLocalNotifications ?? [])
            .compactMap { $0.userInfo }
            .compactMap { $0[userInfoIdentifierKey] as? String }

        DispatchQueue.main.async {
            completion(ids)
        }
    }

    // MARK: - cancel

    open func cancel(identifiers: [String]) {
        let notifications = (application.scheduledLocalNotifications ?? [])
            .filter {
                guard let userInfo = $0.userInfo,
                    let notificationId = userInfo[userInfoIdentifierKey] as? String,
                    identifiers.contains(notificationId) else { return false }
                return true
            }
        for notification in notifications {
            application.cancelLocalNotification(notification)
        }
    }

    open func cancel(identifier: String) {
        let notifications = (application.scheduledLocalNotifications ?? [])
            .filter {
                guard let userInfo = $0.userInfo,
                    let notificationId = userInfo[userInfoIdentifierKey] as? String,
                    notificationId == identifier else { return false }
                return true
            }
        for notification in notifications {
            application.cancelLocalNotification(notification)
        }
    }

    open func cancellAll() {
        application.cancelAllLocalNotifications()
    }

    @objc
    func userNotificationService(_: UIApplication, didReceive notification: UILocalNotification) {
        guard let identifier = notification.userInfo?[userInfoIdentifierKey] as? String else { return }
        var userInfo = notification.userInfo
        userInfo?["body"] = notification.alertBody
        let pushNotification = PushNotification(identifier: identifier,
                                                userInfo: userInfo ?? [:])
        OldUserNotificationServiceImpl.notificationHandlers?
            .handle(pushNotification: pushNotification, applicationState: application.applicationState)
    }

    @objc
    func userNotificationService(_ application: UIApplication,
                                 didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        guard let identifier = userInfo[userInfoIdentifierKey] as? String else { return }
        let pushNotification = PushNotification(identifier: identifier,
                                                userInfo: userInfo)
        OldUserNotificationServiceImpl.notificationHandlers?
            .handle(pushNotification: pushNotification, applicationState: application.applicationState)
    }

    @objc
    func userNotificationService(_ application: UIApplication,
                                 didFailToRegisterForRemoteNotificationsWithError error: Error) {
        OldUserNotificationServiceImpl.apnsHandler?.registerForRemoteNotifications(failWith: error)
    }

    @objc
    func userNotificationService(_ application: UIApplication,
                                 didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        OldUserNotificationServiceImpl.apnsHandler?.registerForRemoteNotifications(completeWithDeviceToken: deviceToken)
    }
}
