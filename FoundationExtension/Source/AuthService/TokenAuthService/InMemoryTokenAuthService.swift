import Foundation
import KeychainSwift

public class InMemoryTokenAuthService: BaseAuthServiceImpl, TokenAuthService {
    // MARK: - TokenAuthService

    private var accessToken: String?

    // MARK: credentials

    override public init(notificationCenter: NotificationCenter) {
        super.init(notificationCenter: notificationCenter)
    }

    open var credentials: TokenAuthCredentials? {
        guard let accessToken = accessToken else { return nil }
        return TokenAuthCredentials(accessToken: accessToken)
    }

    open func save(accessToken: String) {
        self.accessToken = accessToken
        postNotificationDidSignIn()
    }

    open func authHeader() -> [AnyHashable: Any]? {
        guard let credentials = credentials else { return nil }
        return ["Authorization": "Bearer \(credentials.accessToken)"]
    }

    // MARK: - BaseAuthService

    open var isSignedIn: Bool {
        credentials != nil
    }

    open func deleteCredentials() {
        accessToken = nil
        postNotificationDidSignOut()
    }
}
