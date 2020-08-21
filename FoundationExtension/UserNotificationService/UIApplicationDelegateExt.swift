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

    @available(iOS 10.0, *)
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

    @available(iOS, deprecated: 10.0)
    func transferControl(from object: AnyObject, toOldService service: OldUserNotificationServiceImpl) {
        let originalClass: AnyClass! = object_getClass(object)
        let swizzledClass: AnyClass! = object_getClass(service)

        do {
            let originalSelector = #selector(UIApplicationDelegate.application(_:didFailToRegisterForRemoteNotificationsWithError:))
            let swizzledSelector = #selector(OldUserNotificationServiceImpl.userNotificationService(_:didFailToRegisterForRemoteNotificationsWithError:))

            Self.swizzleMethods(origSelector: originalSelector,
                                withSelector: swizzledSelector,
                                forClass: originalClass,
                                swizzledClass: swizzledClass)
        }

        do {
            let originalSelector = #selector(UIApplicationDelegate.application(_:didRegisterForRemoteNotificationsWithDeviceToken:))
            let swizzledSelector = #selector(OldUserNotificationServiceImpl.userNotificationService(_:didFailToRegisterForRemoteNotificationsWithError:))

            Self.swizzleMethods(origSelector: originalSelector,
                                withSelector: swizzledSelector,
                                forClass: originalClass,
                                swizzledClass: swizzledClass)
        }

        do {
            let originalSelector = #selector(UIApplicationDelegate.application(_:didReceive:))
            let swizzledSelector = #selector(OldUserNotificationServiceImpl.userNotificationService(_:didReceive:))

            Self.swizzleMethods(origSelector: originalSelector,
                                withSelector: swizzledSelector,
                                forClass: originalClass,
                                swizzledClass: swizzledClass)
        }

        do {
            let originalSelector = #selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:))
            let swizzledSelector = #selector(OldUserNotificationServiceImpl.userNotificationService(_:didReceiveRemoteNotification:))

            Self.swizzleMethods(origSelector: originalSelector,
                                withSelector: swizzledSelector,
                                forClass: originalClass,
                                swizzledClass: swizzledClass)
        }
    }
}
