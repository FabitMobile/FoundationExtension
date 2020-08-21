// Generated using Sourcery 0.18.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Mirage2 
import CoreLocation

class MockOAuth2Service: OAuth2Service {
    //MARK: - VARIABLES
    //MARK: credentials
    lazy var mock_credentials_get = FuncCallHandler<Void, (OAuth2Credentials?)>(returnValue: anyOAuth2CredentialsOpt())
    var credentials: OAuth2Credentials? {
        get { return mock_credentials_get.handle(()) }
    }

    //MARK: isSignedIn
    lazy var mock_isSignedIn_get = FuncCallHandler<Void, (Bool)>(returnValue: anyBool())
    var isSignedIn: Bool {
        get { return mock_isSignedIn_get.handle(()) }
    }

    //MARK: - FUNCTIONS
    //MARK: save
    class SaveArgs {
        var accessToken: String
        var refreshToken: String
        var accessTokenExpirationDate: Date
        var refreshTokenExpirationDate: Date
        init(_ accessToken: String, _ refreshToken: String, _ accessTokenExpirationDate: Date, _ refreshTokenExpirationDate: Date) {
            self.accessToken = accessToken
            self.refreshToken = refreshToken
            self.accessTokenExpirationDate = accessTokenExpirationDate
            self.refreshTokenExpirationDate = refreshTokenExpirationDate
        }
    }
    lazy var mock_save = FuncCallHandler<SaveArgs, Void>(returnValue: ())    
    func save(accessToken: String,              refreshToken: String,              accessTokenExpirationDate: Date,              refreshTokenExpirationDate: Date) {
        return mock_save.handle(SaveArgs(accessToken, refreshToken, accessTokenExpirationDate, refreshTokenExpirationDate))
    }
    //MARK: isAccessTokenValid
    lazy var mock_isAccessTokenValid = FuncCallHandler<Void, Bool>(returnValue: anyBool())    
    func isAccessTokenValid() -> Bool {
        return mock_isAccessTokenValid.handle(())
    }
    //MARK: isAccessTokenValidWithDate
    lazy var mock_isAccessTokenValidWithDate = FuncCallHandler<Date, Bool>(returnValue: anyBool())    
    func isAccessTokenValid(currentDate: Date) -> Bool {
        return mock_isAccessTokenValidWithDate.handle(currentDate)
    }
    //MARK: isRefreshTokenValid
    lazy var mock_isRefreshTokenValid = FuncCallHandler<Void, Bool>(returnValue: anyBool())    
    func isRefreshTokenValid() -> Bool {
        return mock_isRefreshTokenValid.handle(())
    }
    //MARK: isRefreshTokenValidWithDate
    lazy var mock_isRefreshTokenValidWithDate = FuncCallHandler<Date, Bool>(returnValue: anyBool())    
    func isRefreshTokenValid(currentDate: Date) -> Bool {
        return mock_isRefreshTokenValidWithDate.handle(currentDate)
    }
    //MARK: authHeader
    lazy var mock_authHeader = FuncCallHandler<Void, [AnyHashable: Any]?>(returnValue: anyDictOptOfAnyHashableToAny())    
    func authHeader() -> [AnyHashable: Any]? {
        return mock_authHeader.handle(())
    }
    //MARK: authHeaderWithDate
    lazy var mock_authHeaderWithDate = FuncCallHandler<Date, [AnyHashable: Any]?>(returnValue: anyDictOptOfAnyHashableToAny())    
    func authHeader(currentDate: Date) -> [AnyHashable: Any]? {
        return mock_authHeaderWithDate.handle(currentDate)
    }
    //MARK: deleteCredentials
    lazy var mock_deleteCredentials = FuncCallHandler<Void, Void>(returnValue: ())    
    func deleteCredentials() {
        return mock_deleteCredentials.handle(())
    }
}
