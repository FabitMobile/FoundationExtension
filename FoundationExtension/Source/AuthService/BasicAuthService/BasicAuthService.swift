import Foundation
import KeychainSwift

protocol BasicAuthService: BaseAuthService {
    // MARK: credentials

    var credentials: BasicAuthCredentials? { get }

    func save(login: String, password: String)

    // MARK: authHeader

    func authHeader() -> [AnyHashable: Any]?
    func authHeader(withLogin login: String, password: String) -> [AnyHashable: Any]?
}

class BasicAuthServiceImpl: BaseAuthServiceImpl, BasicAuthService {
    open var userDefaults: UserDefaults

    init(notificationCenter: NotificationCenter,
         userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        super.init(notificationCenter: notificationCenter)
    }

    // MARK: - BasicAuthService

    public let kLastLogin = "authService.lastLogin"

    // MARK: credentials

    open var credentials: BasicAuthCredentials? {
        guard let login = userDefaults.object(forKey: kLastLogin) as? String,
              let password = KeychainSwift().get(login)
        else { return nil }
        return BasicAuthCredentials(login: login,
                                    password: password)
    }

    open func save(login: String, password: String) {
        userDefaults.set(login, forKey: kLastLogin)
        userDefaults.synchronize()

        KeychainSwift().set(password, forKey: login)

        postNotificationDidSignIn()
    }

    // MARK: authHeader

    open func authHeader() -> [AnyHashable: Any]? {
        guard let credentials = credentials else { return nil }
        return authHeader(withLogin: credentials.login,
                          password: credentials.password)
    }

    open func authHeader(withLogin login: String, password: String) -> [AnyHashable: Any]? {
        guard let encodedString = base64Encode(string: "\(login):\(password)") else { return nil }
        return ["Authorization": "Basic \(encodedString)"]
    }

    fileprivate func base64Encode(string: String) -> String? {
        guard let data = string.data(using: .utf8) else { return nil }
        return data.base64EncodedString(options: [])
    }

    // MARK: - BaseAuthService

    open var isSignedIn: Bool {
        credentials != nil
    }

    open func deleteCredentials() {
        guard let credentials = credentials else { return }

        userDefaults.removeObject(forKey: kLastLogin)
        userDefaults.synchronize()

        KeychainSwift().delete(credentials.login)

        postNotificationDidSignOut()
    }
}
