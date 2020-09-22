import Foundation
import UIKit

public typealias DialogServicePickerIndexChanged = (_ index: Int) -> Void
public typealias DialogServicePickerCompletion = (_ index: Int, _ cancelled: Bool) -> Void
public typealias DialogServiceTextFieldConfigurator = (_ textField: UITextField) -> Void

public struct DialogServiceStyle {
    var backgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
    var contentColor: UIColor = .white

    public init() {}
}

public protocol DialogService {
    // MARK: - activity

    func showActivity()
    func showActivity(in view: UIView)
    func showActivity(style: DialogServiceStyle)
    func showActivity(in view: UIView, style: DialogServiceStyle)

    func showActivity(withMessage message: String)
    func showActivity(in view: UIView, withMessage message: String)
    func showActivity(withMessage message: String, style: DialogServiceStyle)
    func showActivity(in view: UIView, withMessage message: String, style: DialogServiceStyle)

    func hideActivity()
    func hideActivity(from view: UIView)

    // MARK: - message

    func showMessage(text: String)
    func showMessage(text: String, in view: UIView)
    func showMessage(text: String, style: DialogServiceStyle)
    func showMessage(text: String, in view: UIView, style: DialogServiceStyle)

    // MARK: - alert

    func showAlert(title: String, message: String, actions: [UIAlertAction])
    func showAlert(title: String,
                   message: String,
                   textFieldConfigurators: [DialogServiceTextFieldConfigurator]?,
                   actions: [UIAlertAction])
    func hideAlert()

    // MARK: - actionSheet

    func showActionSheet(title: String?, message: String?, actions: [UIAlertAction])

    // MARK: - picker

    func showPicker(items: [DialogServicePickerItem],
                    selectedIndex: Int,
                    toolbar: UIToolbar?,
                    indexChanged: @escaping DialogServicePickerIndexChanged,
                    completion: @escaping DialogServicePickerCompletion)
    func cancelPicker()
    func hidePicker()

    // MARK: - share

    func showShareDialog(items: [DialogServiceShareItem])
}

public protocol DialogServiceShareItem {}
extension String: DialogServiceShareItem {}
extension NSAttributedString: DialogServiceShareItem {}
extension URL: DialogServiceShareItem {}
extension UIImage: DialogServiceShareItem {}

public protocol DialogServicePickerItem {}
extension String: DialogServicePickerItem {}
extension NSAttributedString: DialogServicePickerItem {}
