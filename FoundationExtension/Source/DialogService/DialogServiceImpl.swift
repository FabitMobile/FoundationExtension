import Foundation
import MBProgressHUD

// swiftlint:disable type_body_length
// swiftlint:disable file_length
open class DialogServiceImpl: NSObject, DialogService, UIPickerViewDataSource, UIPickerViewDelegate {
    let kDialog_message_view = "kDialog_message_view"
    let kDialog_message_text = "kDialog_message_text"

    let showMessageQueue = DispatchQueue(label: "DialogServiceImpl")
    let synchQueue = DispatchQueue(label: "DialogServiceImplSynch")

    var messageInfos: [[AnyHashable: Any]]
    var pickerItems: [DialogServicePickerItem]?

    var isShowingMessage: Bool = false
    var isPickerCancelled: Bool = false

    var alertController: UIAlertController?

    var vOverlay: UIView?
    var picker: UIPickerView?
    var pickerView: UIView?
    var customDialogView: UIView?
    var pickerPosition: CGFloat?
    var pickerIndexChanged: DialogServicePickerIndexChanged?
    var pickerCompletion: DialogServicePickerCompletion?

    override public init() {
        messageInfos = [[AnyHashable: Any]]()
        super.init()
    }

    open var topView: UIView? {
        mainWindow
    }

    open var mainWindow: UIWindow? {
        UIApplication.shared.keyWindow
    }

    open var topViewController: UIViewController? {
        var viewController = mainWindow?.rootViewController
        while (viewController?.parent) != nil {
            viewController = viewController?.parent
        }
        while (viewController?.presentedViewController) != nil {
            viewController = viewController?.presentedViewController
        }
        return viewController
    }

    // MARK: - activity

    open func showActivity() {
        showActivity(style: DialogServiceStyle())
    }

    open func showActivity(in view: UIView) {
        showActivity(in: view, style: DialogServiceStyle())
    }

    open func showActivity(withMessage message: String) {
        showActivity(withMessage: message, style: DialogServiceStyle())
    }

    open func showActivity(in view: UIView, withMessage message: String) {
        showActivity(in: view, withMessage: message, style: DialogServiceStyle())
    }

    open func showActivity(style: DialogServiceStyle) {
        guard let topView = topView else { return }
        showActivity(in: topView, style: style)
    }

    func makeView(in view: UIView, style: DialogServiceStyle, withText text: String? = nil) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.contentColor = style.contentColor

        hud.bezelView.style = MBProgressHUDBackgroundStyle.solidColor
        hud.bezelView.backgroundColor = style.backgroundColor

        if let text = text {
            hud.label.text = text
            hud.label.numberOfLines = 0
        }

        return hud
    }

    open func showActivity(in view: UIView, style: DialogServiceStyle) {
        DispatchQueue.main.async { [weak self] in
            guard let __self = self else { return }
            _ = __self.makeView(in: view, style: style)
        }
    }

    open func showActivity(withMessage message: String, style: DialogServiceStyle) {
        guard let topView = topView else { return }
        showActivity(in: topView, withMessage: message, style: style)
    }

    open func showActivity(in view: UIView, withMessage message: String, style: DialogServiceStyle) {
        DispatchQueue.main.async { [weak self] in
            guard let __self = self else { return }
            _ = __self.makeView(in: view, style: style, withText: message)
        }
    }

    open func hideActivity() {
        guard let topView = topView else { return }
        hideActivity(from: topView)
    }

    open func hideActivity(from view: UIView) {
        DispatchQueue.main.async {
            guard let huds: [MBProgressHUD] = MBProgressHUD.allHUDs(for: view) as? [MBProgressHUD] else { return }
            for hud: MBProgressHUD in huds.filter({ $0.mode == MBProgressHUDMode.indeterminate }) {
                hud.hide(animated: true)
            }
        }
    }

    // MARK: - message

    open func showMessage(text: String) {
        showMessage(text: text, style: DialogServiceStyle())
    }

    open func showMessage(text: String, in view: UIView) {
        showMessage(text: text, in: view, style: DialogServiceStyle())
    }

    open func showMessage(text: String, style: DialogServiceStyle) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                guard let __self = self else { return }
                __self.showMessage(text: text, style: style)
            }
            return
        }

        guard let topView = topView else { return }
        showMessage(text: text, in: topView, style: style)
    }

    open func showMessage(text: String, in view: UIView, style: DialogServiceStyle) {
        showMessageQueue.async { [weak self] in
            guard let __self = self else { return }
            let last: [AnyHashable: Any] = __self.messageInfos.last ?? [:]
            if last[__self.kDialog_message_view] as? UIView != view
                || last[__self.kDialog_message_text] as? String != text {
                __self.messageInfos.append([
                    __self.kDialog_message_view: view,
                    __self.kDialog_message_text: text
                ])
            }
            __self.tryToShowNextMessage(for: view, style: style)
        }
    }

    open func tryToShowNextMessage(for view: UIView, style: DialogServiceStyle) {
        synchQueue.async { [weak self] in
            guard let __self = self else { return }
            if __self.isShowingMessage == false {
                __self.isShowingMessage = true
                DispatchQueue.main.async { [weak self] in
                    guard let __self = self else { return }
                    let predicate = NSPredicate(format: "kDialog_message_view == %@", view)
                    guard let messageInfo = __self.messageInfos.first(where: { predicate.evaluate(with: $0) }) else {
                        __self.isShowingMessage = false
                        return
                    }
                    if !messageInfo.isEmpty {
                        let hud = __self.makeView(in: view, style: style)

                        hud.removeFromSuperViewOnHide = true
                        hud.mode = MBProgressHUDMode.text
                        if let detailsLabelText = messageInfo[__self.kDialog_message_text] as? String {
                            hud.detailsLabel.text = detailsLabelText
                        }
                        hud.isUserInteractionEnabled = false
                        DispatchQueue.main.async {
                            view.addSubview(hud)
                            hud.show(animated: true)

                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                                hud.hide(animated: true)
                                guard let __self = self else { return }
                                __self.messageInfos.remove(at: 0)
                                __self.isShowingMessage = false
                                __self.tryToShowNextMessage(for: view, style: style)
                            }
                        }

                    } else {
                        __self.isShowingMessage = false
                    }
                }
            }
        }
    }

    // MARK: - alert

    open func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        showAlertController(title: title,
                            message: message,
                            actions: actions,
                            textFieldConfigurators: nil,
                            style: .alert)
    }

    open func showAlert(title: String,
                        message: String,
                        textFieldConfigurators: [DialogServiceTextFieldConfigurator]?,
                        actions: [UIAlertAction]) {
        showAlertController(title: title,
                            message: message,
                            actions: actions,
                            textFieldConfigurators: textFieldConfigurators,
                            style: .alert)
    }

    // MARK: - actionSheet

    open func showActionSheet(title: String?, message: String?, actions: [UIAlertAction]) {
        showAlertController(title: title,
                            message: message,
                            actions: actions,
                            textFieldConfigurators: nil,
                            style: .actionSheet)
    }

    // MARK: - alertController

    open func showAlertController(title: String?,
                                  message: String?,
                                  actions: [UIAlertAction],
                                  textFieldConfigurators: [DialogServiceTextFieldConfigurator]?,
                                  style: UIAlertController.Style) {
        guard let controller = topViewController else { return }
        showAlertController(title: title,
                            message: message,
                            actions: actions,
                            textFieldConfigurators: textFieldConfigurators,
                            style: style,
                            in: controller)
    }

    open func showAlertController(title: String?,
                                  message: String?,
                                  actions: [UIAlertAction],
                                  textFieldConfigurators: [DialogServiceTextFieldConfigurator]?,
                                  style: UIAlertController.Style,
                                  in viewController: UIViewController) {
        if alertController != nil {
            hideAlert()
            alertController = nil
        }

        alertController = UIAlertController(title: title, message: message, preferredStyle: style)

        if #available(iOS 13.0, *) {
            alertController?.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }

        guard let controller = alertController else { return }

        for action in actions {
            controller.addAction(action)
        }

        if style == .alert {
            if let configurators = textFieldConfigurators {
                for configurator in configurators {
                    controller.addTextField(configurationHandler: configurator)
                }
            }
        }
        viewController.present(controller, animated: true)
    }

    open func hideAlert() {
        guard let controller = alertController else { return }
        controller.parent?.dismiss(animated: true)
        alertController = nil
    }

    // MARK: - picker

    open func showPicker(items: [DialogServicePickerItem],
                         selectedIndex: Int,
                         toolbar: UIToolbar?,
                         indexChanged: @escaping DialogServicePickerIndexChanged,
                         completion: @escaping DialogServicePickerCompletion) {
        guard let controller = topViewController else { return }
        showPicker(items: items,
                   selectedIndex: selectedIndex,
                   toolbar: toolbar,
                   indexChanged: indexChanged,
                   completion: completion,
                   in: controller)
    }

    open func showPicker(items: [DialogServicePickerItem],
                         selectedIndex: Int,
                         toolbar: UIToolbar?,
                         indexChanged: @escaping DialogServicePickerIndexChanged,
                         completion: @escaping DialogServicePickerCompletion,
                         in viewController: UIViewController) {
        pickerItems = items
        pickerIndexChanged = indexChanged
        pickerCompletion = completion

        vOverlay = UIView(frame: UIScreen.main.bounds)
        picker = UIPickerView()
        pickerView = UIView()
        // swiftlint:disable force_unwrapping
        pickerView!.backgroundColor = .white
        pickerView!.frame.origin.y = UIScreen.main.bounds.height
        pickerView!.frame.size.height = picker!.frame.size.height
        pickerView!.frame.size.width = UIScreen.main.bounds.width

        do {
            vOverlay!.backgroundColor = UIColor(white: 0, alpha: 0.4)
        }
        vOverlay!.alpha = 0.0
        viewController.view.addSubview(vOverlay!)

        vOverlay!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(overlayDidTap)))

        picker!.dataSource = self
        picker!.delegate = self
        picker!.showsSelectionIndicator = true
        picker!.backgroundColor = UIColor.white
        picker!.reloadAllComponents()
        picker!.selectRow(selectedIndex, inComponent: 0, animated: false)
        picker!.frame.origin = CGPoint(x: pickerView!.frame.size.width / 2 - picker!.frame.size.width / 2,
                                       y: 0)

        if toolbar != nil {
            toolbar!.frame = CGRect(x: 0,
                                    y: 0,
                                    width: UIScreen.main.bounds.width,
                                    height: 44)

            picker!.frame.origin.y = 44
            pickerView!.frame.size.height += toolbar!.frame.size.height
            pickerView!.addSubview(toolbar!)
        }

        pickerView!.addSubview(picker!)

        viewController.view.addSubview(pickerView!)

        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let __self = self else { return }

            __self.pickerView!.frame.origin.y = UIScreen.main.bounds.height - __self.picker!.frame.size.height

            if toolbar != nil {
                __self.pickerView!.frame.origin.y -= toolbar!.frame.size.height
            }

            __self.pickerView!.alpha = 1.0
            __self.vOverlay!.alpha = 1.0
        }
    }

    open func cancelPicker() {
        isPickerCancelled = true
        hidePicker()
    }

    open func hidePicker() {
        if let pickerCompletion = pickerCompletion {
            let cancelled: Bool = isPickerCancelled
            guard let picker = picker else { return }
            DispatchQueue.main.async {
                pickerCompletion(picker.selectedRow(inComponent: 0), cancelled)
            }
        }

        isPickerCancelled = false

        guard let vOverlay = vOverlay, let picker = picker, let pickerView = pickerView else { return }

        UIView.animate(withDuration: 0.25, animations: {
            pickerView.frame.origin.y = UIScreen.main.bounds.height
            pickerView.alpha = 0.0
            vOverlay.alpha = 0.0
        }, completion: { [weak self] (_: Bool) -> Void in
            guard let __self = self else { return }
            pickerView.removeFromSuperview()
            picker.removeFromSuperview()
            vOverlay.removeFromSuperview()

            __self.pickerView = nil
            __self.picker = nil
            __self.vOverlay = nil
            __self.pickerIndexChanged = nil
            __self.pickerCompletion = nil
        })
    }

    @objc
    func overlayDidTap(_: UIGestureRecognizer) {
        cancelPicker()
    }
    
    // MARK: - Custom alerts
    
    public func showCustomDialog(with content: UIView) {
        
        guard let viewController = topViewController else { return }
        
        // Setup overlay
        vOverlay = UIView(frame: UIScreen.main.bounds)
        vOverlay?.backgroundColor = .black
        vOverlay?.alpha = 0.0
        vOverlay?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideCustomDialog)))
        
        // Setup dialog view
        let horizontalPadding: CGFloat = 16
        let squareWidth: CGFloat = UIScreen.main.bounds.width - (horizonalPadding * 2)
        let contentSize = CGSize(width: squareWidth, height: squareWidth)
        let topSafeAreaInset = safeAreaTopInset(for: viewController)
        let position = CGPoint(x: horizonalPadding, y: 32 + topSafeAreaInset)
        
        customDialogView = UIView(frame: CGRect(origin: position, size: contentSize))
        customDialogView?.backgroundColor = .white
        customDialogView?.alpha = 0
        customDialogView?.layer.cornerRadius = 6
        customDialogView?.clipsToBounds = true
        
        // Setup dismiss button
        let buttonSize = CGSize(width: 30, height: 30)
        let buttonPosition = CGPoint(x: contentSize.width - buttonSize.width - 12, y: 12)
        let dismissButton = configureCloseButton(frame: CGRect(origin: buttonPosition, size: buttonSize))
        
        // Add content and close button to dialog view
        content.frame = CGRect(origin: .zero, size: customDialogView!.frame.size)
        customDialogView?.addSubview(content)
        customDialogView?.addSubview(dismissButton)
        
        // Add dialog to main view
        viewController.view.addSubview(vOverlay!)
        viewController.view.addSubview(customDialogView!)
        
        // Showing with animation
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.vOverlay?.alpha = 0.3
            self?.customDialogView?.alpha = 1
        }
    }
    
    @objc
    open func hideCustomDialog() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.vOverlay?.alpha = 0
            self?.customDialogView?.alpha = 0
        } completion: { [weak self] _ in
            self?.vOverlay?.removeFromSuperview()
            self?.customDialogView?.removeFromSuperview()
            self?.vOverlay = nil
            self?.customDialogView = nil
        }

    }

    // MARK: - UIPickerViewDataSource

    open func numberOfComponents(in _: UIPickerView) -> Int {
        1
    }

    open func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        pickerItems!.count
    }

    // MARK: - UIPickerViewDelegate

    open func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        pickerItems![row] as? String
    }

    open func pickerView(_: UIPickerView, attributedTitleForRow row: Int, forComponent _: Int) -> NSAttributedString? {
        pickerItems![row] as? NSAttributedString
    }

    open func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        if let pickerIndexChanged = pickerIndexChanged {
            pickerIndexChanged(row)
        }
    }

    // MARK: - share

    open func showShareDialog(items: [DialogServiceShareItem], style: DialogServiceStyle) {
        showActivity(style: style)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let __self = self else { return }
            DispatchQueue.main.async {
                let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
                guard let controller = __self.topViewController else { return }
                controller.present(activityVC, animated: true) {
                    __self.hideActivity()
                }
            }
        }
    }

    open func showShareDialog(items: [DialogServiceShareItem]) {
        showShareDialog(items: items, style: DialogServiceStyle())
    }
    
    // MARK: - Private
    private func safeAreaTopInset(for viewController: UIViewController?) -> CGFloat {
        guard let viewController = viewController else { return 0 }
        
        if #available(iOS 11.0, *) {
            return viewController.view.safeAreaInsets.top
        } else {
            return viewController.topLayoutGuide.length
        }
    }
    
    private func configureCloseButton(frame: CGRect) -> UIButton {
        
        var button: UIButton?
        
        if #available(iOS 13.0, *) {
            button = UIButton(type: .system)
            button?.frame = frame
            button?.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            button?.contentVerticalAlignment = .fill
            button?.contentHorizontalAlignment = .fill
            button?.tintColor = UIColor(hue: 0, saturation: 0, brightness: 0.8, alpha: 1)
        } else {
            button = UIButton(frame: frame)
            button?.setTitle("×", for: .normal)
            button?.setTitleColor(.white, for: .normal)
            button?.layer.masksToBounds = true
            button?.layer.cornerRadius = 15
            button?.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.8, alpha: 1)
        }
        
        button?.addTarget(self, action: #selector(hideCustomDialog), for: .touchUpInside)
        
        return button!
    }
}
