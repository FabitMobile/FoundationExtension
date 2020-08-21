import Foundation

public struct BasicAuthCredentials {
    var login: String
    var password: String

    init(login: String,
         password: String) {
        self.login = login
        self.password = password
    }
}
