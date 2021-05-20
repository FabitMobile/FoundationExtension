import Foundation

public enum UserNotificationType {
    case local
    case remote
}

// sourcery: mirageMock
public protocol UserNotificationService: AnyObject {
    // MARK: - permissions

    func permissionsStatus(_ completion: @escaping ((NotificationPermissions?) -> Void))

    // MARK: - register

    func registerForNotifications(_ types: [UserNotificationType])
    func unregisterForRemoteNotifications()

    // MARK: - schedule

    func schedule(identifier: String,
                  date: Date,
                  body: String,
                  userInfo: [AnyHashable: Any]?)

    // sourcery: mirageSel=scheduleAvailableIOS10
    func schedule(identifier: String,
                  date: Date,
                  title: String?,
                  subtitle: String?,
                  body: String,
                  userInfo: [AnyHashable: Any]?)

    func scheduledNotifications(_ completion: @escaping ([String]) -> Void)

    // MARK: - cancel

    // sourcery: mirageSel=cancel_identifiers
    func cancel(identifiers: [String])
    func cancel(identifier: String)
    func cancellAll()
}
