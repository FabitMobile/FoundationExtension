// Generated using Sourcery 0.18.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Mirage2 
import CoreLocation

class MockApplePayService: ApplePayService {
    //MARK: - VARIABLES
    //MARK: isAvailable
    lazy var mock_isAvailable_get = FuncCallHandler<Void, (Bool)>(returnValue: anyBool())
    var isAvailable: Bool {
        get { return mock_isAvailable_get.handle(()) }
    }

    //MARK: - FUNCTIONS
    //MARK: makeTransaction
    lazy var mock_makeTransaction = FuncCallHandler<[ApplePayServiceItem], ApplePayTransaction?>(returnValue: anyApplePayTransactionOpt())    
    func makeTransaction(items: [ApplePayServiceItem]) -> ApplePayTransaction? {
        return mock_makeTransaction.handle(items)
    }
}
