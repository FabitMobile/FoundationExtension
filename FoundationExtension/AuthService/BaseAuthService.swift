import Foundation

public protocol BaseAuthService {
    var isSignedIn: Bool { get }

    func deleteCredentials()
}

open class BaseAuthServiceImpl {
    open var kKeychainService: String {
        guard let bundleId = Bundle.main.bundleIdentifier else { return "" }
        return bundleId + ".authService.password"
    }

    open var notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }

    // MARK: - notifications

    open func postNotificationDidSignIn() {
        notificationCenter.post(name: Notification.Name.AuthServiceDidSignIn,
                                object: self)
    }

    open func postNotificationDidSignOut() {
        notificationCenter.post(name: Notification.Name.AuthServiceDidSignOut,
                                object: self)
    }
}

public extension Notification.Name {
    static let AuthServiceDidSignIn = Notification.Name("kAuthService_didSignInNotification")
    static let AuthServiceDidSignOut = Notification.Name("kAuthService_didSignOutNotification")
}
