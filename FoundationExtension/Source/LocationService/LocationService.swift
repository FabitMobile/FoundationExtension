import CoreLocation
import Foundation

public enum LocationUsage {
    case always
    case whenInUse
}

// sourcery: mirageMock
public protocol LocationService {
    var lastLocation: CLLocation? { get set }
    var authorizationStatus: CLAuthorizationStatus { get }
    var onAuthorizationStatusChanged: ((CLLocationManager, CLAuthorizationStatus) -> Void)? { get set }

    var onFailedWithError: ((CLLocationManager, Error) -> Void)? { get set }

    func requestAuthorization(usage: LocationUsage)

    @available(iOS 9.0, *)
    func requestOneTimeLocation()

    func startMonitoring()
    func stopMonitoring()
}

let LocationServiceLocationKey = "LocationService_LocationKey"
public let LocationServiceStatusKey = "LocationService_StatusKey"

open class LocationServiceImpl: NSObject, LocationService, CLLocationManagerDelegate {
    var notificationCenter: NotificationCenter

    public var lastLocation: CLLocation? {
        didSet {
            notifyLocationChanged()
        }
    }

    public var authorizationStatus: CLAuthorizationStatus { CLLocationManager.authorizationStatus() }

    public var onAuthorizationStatusChanged: ((CLLocationManager, CLAuthorizationStatus) -> Void)?
    public var onFailedWithError: ((CLLocationManager, Error) -> Void)?

    let locationManager: CLLocationManager

    public init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
        locationManager = CLLocationManager()
        lastLocation = locationManager.location
    }

    func notifyLocationChanged() {
        var userInfo: [String: Any] = [:]
        if let lastLocation = self.lastLocation {
            userInfo[LocationServiceLocationKey] = lastLocation
        }
        notificationCenter.post(name: Notification.Name.LocationServiceLocationChanged,
                                object: self,
                                userInfo: userInfo)
    }

    public func requestAuthorization(usage: LocationUsage) {
        guard CLLocationManager.locationServicesEnabled() == true else { return }

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters

        switch usage {
        case .whenInUse:
            locationManager.requestWhenInUseAuthorization()

        case .always:
            locationManager.requestAlwaysAuthorization()
        }
    }

    @available(iOS 9.0, *)
    public func requestOneTimeLocation() {
        guard CLLocationManager.locationServicesEnabled() == true else { return }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestLocation()
    }

    public func startMonitoring() {
        locationManager.startUpdatingLocation()
    }

    public func stopMonitoring() {
        locationManager.stopUpdatingLocation()
    }

    // MARK: - CLLocationManagerDelegate

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations _: [CLLocation]) {
        if lastLocation?.coordinate.latitude != manager.location?.coordinate.latitude,
            lastLocation?.coordinate.longitude != manager.location?.coordinate.longitude {
            lastLocation = manager.location
        }
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let userInfo = [LocationServiceStatusKey: status]
        notificationCenter.post(name: NSNotification.Name.LocationServiceDidChangeAuthorization,
                                object: self,
                                userInfo: userInfo)
        if let onAuthorizationStatusChanged = onAuthorizationStatusChanged {
            onAuthorizationStatusChanged(manager, status)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let onFailedWithError = onFailedWithError {
            onFailedWithError(manager, error)
        }
    }
}

public extension Notification.Name {
    static let LocationServiceLocationChanged = Notification.Name("LocationService_LocationChanged")
    static let LocationServiceDidChangeAuthorization = Notification.Name("LocationService_DidChangeAuthorization")
}
