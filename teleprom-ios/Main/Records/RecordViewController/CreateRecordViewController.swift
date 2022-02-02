//
//  RecordViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/29/21.
//

import UIKit

class CreateRecordViewController: BaseViewController {

    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var contentTextView: UITextView!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var textViewModifier: TextModifierView!
    @IBOutlet private weak var textModifierBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var contentTextViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var blurBackgroundViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomSafeAreaView: UIView!
    @IBOutlet private weak var backgroundBlurView: UIView!
    
    private var contentTextViewPlaceholderLabel: UILabel!
    private var record: Record?
    private var firstLayoutTime = true
    private let maxTextCount = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textViewModifier.setTextView(contentTextView)
        setRecordIfNeeded()
        initUI()
        addKeyboardObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.backgroundColor = .tabBarGray
        backgroundView.backgroundColor = .controllerGray
        view.backgroundColor = .tabBarGray
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if firstLayoutTime {
            firstLayoutTime = false
            contentTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom + textViewModifier.getInitialHeight(), right: 0)
            blurBackgroundViewHeightConstraint.constant = textViewModifier.getInitialHeight() + view.safeAreaInsets.bottom
            setBottomSafeAreaView()
        }
    }
    
    func setRecord(_ record: Record) {
        self.record = record
    }
    
    private func setRecordIfNeeded() {
        if record == nil {
            record = Record()
        }
    }
    
    private func initUI() {
        titleTextField.text = record?.getTitle()
        contentTextView.attributedText = record?.getText()
        
        setNavBarButtons()
        setTitleTextField()
        setConetentTextView()
        addDoneButtonOnKeyboard()
        IAPManager.shared.checkPermissions { [weak self] hasPermission in
            self?.title = hasPermission ? "" : "\(self?.contentTextView.text.count ?? 0)/1000"
        }
    }
    
    private func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .black
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "create.record.toolbar.title".localized, style: .done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = .white
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        contentTextView.inputAccessoryView = doneToolbar
        titleTextField.inputAccessoryView = doneToolbar
    }
    
    @objc private func doneButtonAction() {
        view.endEditing(true)
    }
    
    private func setTitleTextField() {
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        titleTextField.attributedPlaceholder = NSAttributedString(
            string: "create.record.title.text.placeholder".localized ,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    private func setConetentTextView() {
        contentTextView.delegate = self
        contentTextViewPlaceholderLabel = UILabel()
        contentTextViewPlaceholderLabel.text = "create.record.content.text.placeholder".localized
        contentTextViewPlaceholderLabel.font = UIFont.systemFont(ofSize: (contentTextView.font?.pointSize)!)
        contentTextViewPlaceholderLabel.sizeToFit()
        contentTextView.addSubview(contentTextViewPlaceholderLabel)
        contentTextViewPlaceholderLabel.frame.origin = CGPoint(x: 5, y: (contentTextView.font?.pointSize)! / 2.6)
        contentTextViewPlaceholderLabel.textColor = UIColor.lightGray
        contentTextViewPlaceholderLabel.isHidden = !contentTextView.text.isEmpty
    }
    
    private func setNavBarButtons() {
        let rightBarButtonItem = UIBarButtonItem(title: "record.navbar.save".localized, style: .plain, target: self, action: #selector(saveButtonAction))
        rightBarButtonItem.tintColor = .telepromPink
        navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
        rightBarButtonItem.isEnabled = titleTextField.text?.isEmpty == false || !contentTextView.text.isEmpty
    }
    
    private func setBottomSafeAreaView() {
        let effectView = VisualEffectWithIntensityView(effect:  UIBlurEffect(style: .light), intensity: 0.4)
        backgroundBlurView.insertSubview(effectView, at: 0)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: effectView, attribute: .leading, relatedBy: .equal, toItem: backgroundBlurView, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: effectView, attribute: .trailing, relatedBy: .equal, toItem: backgroundBlurView, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: effectView, attribute: .top, relatedBy: .equal, toItem: backgroundBlurView, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: effectView, attribute: .bottom, relatedBy: .equal, toItem: backgroundBlurView, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    private func textLimit(existingText: String?,
                           newText: String,
                           limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }
    
    override func keyboardDidHide() {
        textModifierBottomConstraint.constant = 0
        contentTextViewBottomConstraint.constant = 0
        blurBackgroundViewHeightConstraint.constant = textViewModifier.getInitialHeight() + view.safeAreaInsets.bottom
    }
    
    override func keyboardDidShow(_ size: CGRect) {
        textModifierBottomConstraint.constant = size.height - view.safeAreaInsets.bottom
        contentTextViewBottomConstraint.constant = size.height - view.safeAreaInsets.bottom
        blurBackgroundViewHeightConstraint.constant = size.height + textViewModifier.getInitialHeight()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        navigationItem.rightBarButtonItem?.isEnabled = textField.text?.isEmpty == false && !contentTextView.text.isEmpty
    }
    
    @objc private func saveButtonAction() {
        guard let record = record else { return }
        
        record.setTitle(titleTextField.text ?? "")
        record.setText(contentTextView.attributedText)
        RecordDataProvider.shared.add(record)
        navigationController?.popViewController(animated: true)
    }
}

extension CreateRecordViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if !IAPManager.shared.getLastSubscribedState() {
            title = "\(textView.text.count)/\(maxTextCount)"
        }
        
        textViewModifier.textViewDidChange()
        contentTextViewPlaceholderLabel.isHidden = !textView.text.isEmpty
        navigationItem.rightBarButtonItem?.isEnabled = !textView.text.isEmpty && titleTextField.text?.isEmpty == false
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if !IAPManager.shared.getLastSubscribedState() {
            return textLimit(existingText: textView.text,
                                  newText: text,
                                  limit: maxTextCount)
        }
        
        return true
    }
}
