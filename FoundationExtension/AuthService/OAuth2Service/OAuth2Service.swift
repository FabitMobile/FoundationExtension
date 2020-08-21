import Foundation
import KeychainSwift

// sourcery: mirageMock
public protocol OAuth2Service: BaseAuthService {
    // MARK: credentials

    var credentials: OAuth2Credentials? { get }

    func save(accessToken: String,
              refreshToken: String,
              accessTokenExpirationDate: Date,
              refreshTokenExpirationDate: Date)

    func isAccessTokenValid() -> Bool
    // sourcery: mirageSel=isAccessTokenValidWithDate
    func isAccessTokenValid(currentDate: Date) -> Bool

    func isRefreshTokenValid() -> Bool
    // sourcery: mirageSel=isRefreshTokenValidWithDate
    func isRefreshTokenValid(currentDate: Date) -> Bool

    // MARK: authHeader

    func authHeader() -> [AnyHashable: Any]?
    // sourcery: mirageSel=authHeaderWithDate
    func authHeader(currentDate: Date) -> [AnyHashable: Any]?
}

open class OAuth2ServiceImpl: BaseAuthServiceImpl, OAuth2Service {
    // MARK: - TokenAuthService

    public let kKeychainAccount = "accessToken"

    // MARK: credentials

    override public init(notificationCenter: NotificationCenter) {
        super.init(notificationCenter: notificationCenter)
    }

    open var credentials: OAuth2Credentials? {
        guard let token = KeychainSwift().get(kKeychainAccount) else { return nil }
        do {
            return try OAuth2Credentials(string: token)
        } catch {
            return nil
        }
    }

    open func save(accessToken: String,
                   refreshToken: String,
                   accessTokenExpirationDate: Date,
                   refreshTokenExpirationDate: Date) {
        let credentials = OAuth2Credentials(accessToken: accessToken,
                                            refreshToken: refreshToken,
                                            accessTokenExpirationDate: accessTokenExpirationDate,
                                            refreshTokenExpirationDate: refreshTokenExpirationDate)
        let token = credentials.toString()
        KeychainSwift().set(token, forKey: kKeychainAccount)
        postNotificationDidSignIn()
    }

    // MARK: authHeader

    public func authHeader(currentDate: Date) -> [AnyHashable: Any]? {
        guard isAccessTokenValid(currentDate: currentDate) == true,
            let credentials = credentials else { return nil }
        return ["Authorization": "Bearer \(credentials.accessToken)"]
    }

    public func authHeader() -> [AnyHashable: Any]? {
        authHeader(currentDate: Date())
    }

    public func isAccessTokenValid(currentDate: Date) -> Bool {
        guard let credentials = credentials else { return false }
        let expirationDate = credentials.accessTokenExpirationDate

        return expirationDate.timeIntervalSince(currentDate) > 0
    }

    public func isRefreshTokenValid(currentDate: Date) -> Bool {
        guard let credentials = credentials else { return false }
        let expirationDate = credentials.refreshTokenExpirationDate
        return expirationDate.timeIntervalSince(currentDate) > 0
    }

    public func isAccessTokenValid() -> Bool {
        isAccessTokenValid(currentDate: Date())
    }

    public func isRefreshTokenValid() -> Bool {
        isRefreshTokenValid(currentDate: Date())
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
