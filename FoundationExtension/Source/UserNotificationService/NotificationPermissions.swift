import Foundation
import UserNotifications

public enum NotificationsPermissionStatus {
    case allowed, denied

    @available(iOS 10.0, *)
    init(_ notificationSetting: UNNotificationSetting) {
        switch notificationSetting {
        case .notSupported, .disabled:
            self = .denied
        case .enabled:
            self = .allowed
        }
    }

    @available(iOS 10.0, *)
    init(_ status: UNAuthorizationStatus) {
        switch status {
        case .authorized, .provisional:
            self = .allowed
        case .notDetermined, .denied:
            self = .denied
        }
    }
}

public struct NotificationPermissions: Equatable {
    public let authorizationStatus: NotificationsPermissionStatus
    public let lockScreenStatus: NotificationsPermissionStatus
    public let notificationCenterStatus: NotificationsPermissionStatus
    public let badgeStatus: NotificationsPermissionStatus

    public init(authorizationStatus: NotificationsPermissionStatus,
                lockScreenStatus: NotificationsPermissionStatus,
                notificationCenterStatus: NotificationsPermissionStatus,
                badgeStatus: NotificationsPermissionStatus) {
        self.authorizationStatus = authorizationStatus
        self.lockScreenStatus = lockScreenStatus
        self.notificationCenterStatus = notificationCenterStatus
        self.badgeStatus = badgeStatus
    }
}
