import Foundation
import KeychainSwift

public protocol TokenAuthService: BaseAuthService {
    // MARK: credentials

    var credentials: TokenAuthCredentials? { get }

    func save(accessToken: String)

    func authHeader() -> [AnyHashable: Any]?
}

public class TokenAuthServiceImpl: BaseAuthServiceImpl, TokenAuthService {
    // MARK: - TokenAuthService

    let kKeychainAccount = "accessToken"

    // MARK: credentials

    open var credentials: TokenAuthCredentials? {
        guard let accessToken = KeychainSwift().get(kKeychainAccount) else { return nil }
        return TokenAuthCredentials(accessToken: accessToken)
    }

    open func save(accessToken: String) {
        KeychainSwift().set(accessToken, forKey: kKeychainAccount)
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
        KeychainSwift().delete(kKeychainAccount)
        postNotificationDidSignOut()
    }
}
