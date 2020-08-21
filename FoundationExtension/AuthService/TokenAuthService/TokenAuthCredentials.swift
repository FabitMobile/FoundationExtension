import Foundation

public struct TokenAuthCredentials {
    var accessToken: String

    init(accessToken: String) {
        self.accessToken = accessToken
    }
}
