// Generated using Sourcery 0.18.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Mirage2 
import CoreLocation

class MockLocationService: LocationService {
    //MARK: - VARIABLES
    //MARK: lastLocation
    lazy var mock_lastLocation_get = FuncCallHandler<Void, (CLLocation?)>(returnValue: anyCLLocationOpt())
    lazy var mock_lastLocation_set = FuncCallHandler<CLLocation?, Void>(returnValue: ())
    var lastLocation: CLLocation? {
        get { return mock_lastLocation_get.handle(()) }
        set(value) { mock_lastLocation_set.handle(value) }
    }

    //MARK: authorizationStatus
    lazy var mock_authorizationStatus_get = FuncCallHandler<Void, (CLAuthorizationStatus)>(returnValue: anyCLAuthorizationStatus())
    var authorizationStatus: CLAuthorizationStatus {
        get { return mock_authorizationStatus_get.handle(()) }
    }

    //MARK: onAuthorizationStatusChanged
    lazy var mock_onAuthorizationStatusChanged_get = FuncCallHandler<Void, (((CLLocationManager, CLAuthorizationStatus) -> Void)?)>(returnValue: anyClosureOptGettingCLLocationManagerCLAuthorizationStatusReturningVoid())
    lazy var mock_onAuthorizationStatusChanged_set = FuncCallHandler<((CLLocationManager, CLAuthorizationStatus) -> Void)?, Void>(returnValue: ())
    var onAuthorizationStatusChanged: ((CLLocationManager, CLAuthorizationStatus) -> Void)? {
        get { return mock_onAuthorizationStatusChanged_get.handle(()) }
        set(value) { mock_onAuthorizationStatusChanged_set.handle(value) }
    }

    //MARK: onFailedWithError
    lazy var mock_onFailedWithError_get = FuncCallHandler<Void, (((CLLocationManager, Error) -> Void)?)>(returnValue: anyClosureOptGettingCLLocationManagerErrorReturningVoid())
    lazy var mock_onFailedWithError_set = FuncCallHandler<((CLLocationManager, Error) -> Void)?, Void>(returnValue: ())
    var onFailedWithError: ((CLLocationManager, Error) -> Void)? {
        get { return mock_onFailedWithError_get.handle(()) }
        set(value) { mock_onFailedWithError_set.handle(value) }
    }

    //MARK: - FUNCTIONS
    //MARK: requestAuthorization
    lazy var mock_requestAuthorization = FuncCallHandler<LocationUsage, Void>(returnValue: ())    
    func requestAuthorization(usage: LocationUsage) {
        return mock_requestAuthorization.handle(usage)
    }
    //MARK: requestOneTimeLocation
    lazy var mock_requestOneTimeLocation = FuncCallHandler<Void, Void>(returnValue: ())    
    func requestOneTimeLocation() {
        return mock_requestOneTimeLocation.handle(())
    }
    //MARK: startMonitoring
    lazy var mock_startMonitoring = FuncCallHandler<Void, Void>(returnValue: ())    
    func startMonitoring() {
        return mock_startMonitoring.handle(())
    }
    //MARK: stopMonitoring
    lazy var mock_stopMonitoring = FuncCallHandler<Void, Void>(returnValue: ())    
    func stopMonitoring() {
        return mock_stopMonitoring.handle(())
    }
}
