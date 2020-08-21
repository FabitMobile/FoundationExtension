// Generated using Sourcery 0.18.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Mirage2 
import CoreLocation

class MockApplePayTransaction: ApplePayTransaction {
    //MARK: - VARIABLES
    //MARK: onResponse
    lazy var mock_onResponse_get = FuncCallHandler<Void, (ApplePayTransactionResponseBlock?)>(returnValue: anyClosureOptGettingApplePayResponseReturningVoid())
    lazy var mock_onResponse_set = FuncCallHandler<ApplePayTransactionResponseBlock?, Void>(returnValue: ())
    var onResponse: ApplePayTransactionResponseBlock? {
        get { return mock_onResponse_get.handle(()) }
        set(value) { mock_onResponse_set.handle(value) }
    }

    //MARK: onSheetDimiss
    lazy var mock_onSheetDimiss_get = FuncCallHandler<Void, (ApplePaySheetDismissBlock?)>(returnValue: anyClosureOptGettingVoidReturningVoid())
    lazy var mock_onSheetDimiss_set = FuncCallHandler<ApplePaySheetDismissBlock?, Void>(returnValue: ())
    var onSheetDimiss: ApplePaySheetDismissBlock? {
        get { return mock_onSheetDimiss_get.handle(()) }
        set(value) { mock_onSheetDimiss_set.handle(value) }
    }

    //MARK: - FUNCTIONS
    //MARK: start
    lazy var mock_start = FuncCallHandler<Void, Void>(returnValue: ())    
    func start() {
        return mock_start.handle(())
    }
    //MARK: finish
    class FinishArgs {
        var success: Bool
        var completion: ApplePaySheetDismissBlock?
        init(_ success: Bool, _ completion: ApplePaySheetDismissBlock?) {
            self.success = success
            self.completion = completion
        }
    }
    lazy var mock_finish = FuncCallHandler<FinishArgs, Void>(returnValue: ())    
    func finish(success: Bool, _ completion: ApplePaySheetDismissBlock?) {
        return mock_finish.handle(FinishArgs(success, completion))
    }
}
