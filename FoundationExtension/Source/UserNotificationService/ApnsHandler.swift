import Foundation

public protocol ApnsHandler {
    func registerForRemoteNotifications(completeWithDeviceToken deviceToken: Data)
    func registerForRemoteNotifications(failWith error: Error)
}
