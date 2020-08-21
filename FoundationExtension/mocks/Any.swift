import CoreLocation
import Foundation

func anyBool() -> Bool {
    true
}

func anyApplePayTransactionOpt() -> ApplePayTransaction? {
    MockApplePayTransaction()
}

func anyClosureOptGettingApplePayResponseReturningVoid() -> ApplePayTransactionResponseBlock? {
    nil
}

func anyClosureOptGettingVoidReturningVoid() -> ApplePaySheetDismissBlock? {
    nil
}

func anyOAuth2CredentialsOpt() -> OAuth2Credentials? {
    nil
}

func anyDictOptOfAnyHashableToAny() -> [AnyHashable: Any] {
    [:]
}

func anyCLLocationOpt() -> CLLocation? {
    CLLocation(latitude: 0, longitude: 0)
}

func anyCLAuthorizationStatus() -> CLAuthorizationStatus {
    CLAuthorizationStatus.authorizedAlways
}

func anyClosureOptGettingCLLocationManagerCLAuthorizationStatusReturningVoid() -> ((CLLocationManager, CLAuthorizationStatus) -> Void)? {
    nil
}

func anyClosureOptGettingCLLocationManagerErrorReturningVoid() -> ((CLLocationManager, Error) -> Void)? {
    nil
}
