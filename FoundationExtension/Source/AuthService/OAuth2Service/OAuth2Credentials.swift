import Foundation

public struct OAuth2Credentials {
    public var accessToken: String
    public var refreshToken: String
    public var accessTokenExpirationDate: Date
    public var refreshTokenExpirationDate: Date

    public init(accessToken: String,
                refreshToken: String,
                accessTokenExpirationDate: Date,
                refreshTokenExpirationDate: Date) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.accessTokenExpirationDate = accessTokenExpirationDate
        self.refreshTokenExpirationDate = refreshTokenExpirationDate
    }

    public init(string: String) throws {
        let comp = string.components(separatedBy: OAuth2Credentials.separator)
        guard comp.count == 4 else { throw InvalidString() }

        let accessToken = comp[0]
        let refreshToken = comp[1]

        guard let accessTokenExpirationDateTimestamp = Double(comp[2]) else { throw InvalidString() }
        guard let refreshTokenExpirationDateTimestamp = Double(comp[3]) else { throw InvalidString() }

        let accessTokenExpirationDate = Date(timeIntervalSince1970: accessTokenExpirationDateTimestamp)
        let refreshTokenExpirationDate = Date(timeIntervalSince1970: refreshTokenExpirationDateTimestamp)

        self.init(accessToken: accessToken,
                  refreshToken: refreshToken,
                  accessTokenExpirationDate: accessTokenExpirationDate,
                  refreshTokenExpirationDate: refreshTokenExpirationDate)
    }

    fileprivate static let separator = "]/["

    public func toString() -> String {
        let separator = OAuth2Credentials.separator
        return accessToken + separator +
            refreshToken + separator +
            "\(Int(accessTokenExpirationDate.timeIntervalSince1970))" + separator +
            "\(Int(refreshTokenExpirationDate.timeIntervalSince1970))"
    }
}

struct InvalidString: Error {}
