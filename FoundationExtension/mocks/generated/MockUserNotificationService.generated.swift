// Generated using Sourcery 0.18.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Mirage2 
import CoreLocation

class MockUserNotificationService: UserNotificationService {
    //MARK: - VARIABLES
    //MARK: - FUNCTIONS
    //MARK: permissionsStatus
    lazy var mock_permissionsStatus = FuncCallHandler<((NotificationPermissions?) -> Void), Void>(returnValue: ())    
    func permissionsStatus(_ completion: @escaping ((NotificationPermissions?) -> Void)) {
        return mock_permissionsStatus.handle(completion)
    }
    //MARK: registerForNotifications
    lazy var mock_registerForNotifications = FuncCallHandler<[UserNotificationType], Void>(returnValue: ())    
    func registerForNotifications(_ types: [UserNotificationType]) {
        return mock_registerForNotifications.handle(types)
    }
    //MARK: unregisterForRemoteNotifications
    lazy var mock_unregisterForRemoteNotifications = FuncCallHandler<Void, Void>(returnValue: ())    
    func unregisterForRemoteNotifications() {
        return mock_unregisterForRemoteNotifications.handle(())
    }
    //MARK: schedule
    class ScheduleArgs {
        var identifier: String
        var date: Date
        var body: String
        var userInfo: [AnyHashable: Any]?
        init(_ identifier: String, _ date: Date, _ body: String, _ userInfo: [AnyHashable: Any]?) {
            self.identifier = identifier
            self.date = date
            self.body = body
            self.userInfo = userInfo
        }
    }
    lazy var mock_schedule = FuncCallHandler<ScheduleArgs, Void>(returnValue: ())    
    func schedule(identifier: String,                  date: Date,                  body: String,                  userInfo: [AnyHashable: Any]?) {
        return mock_schedule.handle(ScheduleArgs(identifier, date, body, userInfo))
    }
    //MARK: scheduleAvailableIOS10
    class ScheduleAvailableIOS10Args {
        var identifier: String
        var date: Date
        var title: String?
        var subtitle: String?
        var body: String
        var userInfo: [AnyHashable: Any]?
        init(_ identifier: String, _ date: Date, _ title: String?, _ subtitle: String?, _ body: String, _ userInfo: [AnyHashable: Any]?) {
            self.identifier = identifier
            self.date = date
            self.title = title
            self.subtitle = subtitle
            self.body = body
            self.userInfo = userInfo
        }
    }
    lazy var mock_scheduleAvailableIOS10 = FuncCallHandler<ScheduleAvailableIOS10Args, Void>(returnValue: ())    
    func schedule(identifier: String,                  date: Date,                  title: String?,                  subtitle: String?,                  body: String,                  userInfo: [AnyHashable: Any]?) {
        return mock_scheduleAvailableIOS10.handle(ScheduleAvailableIOS10Args(identifier, date, title, subtitle, body, userInfo))
    }
    //MARK: scheduledNotifications
    lazy var mock_scheduledNotifications = FuncCallHandler<([String]) -> Void, Void>(returnValue: ())    
    func scheduledNotifications(_ completion: @escaping ([String]) -> Void) {
        return mock_scheduledNotifications.handle(completion)
    }
    //MARK: cancel_identifiers
    lazy var mock_cancel_identifiers = FuncCallHandler<[String], Void>(returnValue: ())    
    func cancel(identifiers: [String]) {
        return mock_cancel_identifiers.handle(identifiers)
    }
    //MARK: cancel
    lazy var mock_cancel = FuncCallHandler<String, Void>(returnValue: ())    
    func cancel(identifier: String) {
        return mock_cancel.handle(identifier)
    }
    //MARK: cancellAll
    lazy var mock_cancellAll = FuncCallHandler<Void, Void>(returnValue: ())    
    func cancellAll() {
        return mock_cancellAll.handle(())
    }
}
