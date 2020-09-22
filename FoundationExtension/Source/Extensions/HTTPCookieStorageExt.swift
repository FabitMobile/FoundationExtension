import Foundation

public extension HTTPCookieStorage {
    static func deleteSharedCookies() {
        let cookies = shared.cookies
        cookies?.forEach { cookie in
            shared.deleteCookie(cookie)
        }
    }
}
