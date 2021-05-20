import Foundation
import UIKit

// swiftlint:disable force_unwrapping
// swiftlint:disable line_length
extension UIApplicationDelegate {
    fileprivate static func swizzleMethods(origSelector: Selector,
                                           withSelector: Selector,
                                           forClass originalClass: AnyClass,
                                           swizzledClass: AnyClass) {
        let originalMethod = class_getInstanceMethod(originalClass, origSelector)
        let swizzledMethod = class_getInstanceMethod(swizzledClass, withSelector)
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }

    func transferControl(from object: AnyObject, to service: UserNotificationServiceImpl) {
        let originalClass: AnyClass! = object_getClass(object)
        let swizzledClass: AnyClass! = object_getClass(service)

        Self.swizzleMethods(origSelector: #selector(UIApplicationDelegate.application(_:didFailToRegisterForRemoteNotificationsWithError:)),
                            withSelector: #selector(UserNotificationServiceImpl.userNotificationService(_:didFailToRegisterForRemoteNotificationsWithError:)),
                            forClass: originalClass,
                            swizzledClass: swizzledClass)

        Self.swizzleMethods(origSelector: #selector(UIApplicationDelegate.application(_:didRegisterForRemoteNotificationsWithDeviceToken:)),
                            withSelector: #selector(UserNotificationServiceImpl.userNotificationService(_:didRegisterForRemoteNotificationsWithDeviceToken:)),
                            forClass: originalClass,
                            swizzledClass: swizzledClass)
    }
}
