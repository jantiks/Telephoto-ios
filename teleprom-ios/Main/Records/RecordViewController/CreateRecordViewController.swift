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
    
    private var contentTextViewPlaceholderLabel: UILabel!

    private var record: Record?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        navigationController?.navigationBar.barTintColor = .controllerGray
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
        titleTextField.text = record?.title
        contentTextView.text = record?.text
        
        title = "\(contentTextView.text.count)/1000"
        
        setNavBarButtons()
        setTextModifierBg()
        setTitleTextField()
        setConetentTextView()
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
        contentTextViewPlaceholderLabel.font = UIFont.italicSystemFont(ofSize: (contentTextView.font?.pointSize)!)
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
    
    private func setTextModifierBg() {
        let effectView = VisualEffectWithIntensityView(effect:  UIBlurEffect(style: .light), intensity: 0.4)
        textViewModifier.insertSubview(effectView, at: 0)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: effectView, attribute: .leading, relatedBy: .equal, toItem: textViewModifier, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: effectView, attribute: .trailing, relatedBy: .equal, toItem: textViewModifier, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: effectView, attribute: .top, relatedBy: .equal, toItem: textViewModifier, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: effectView, attribute: .bottom, relatedBy: .equal, toItem: textViewModifier, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    override func keyboardDidHide() {
        textModifierBottomConstraint.constant = 0
    }
    
    override func keyboardDidShow(_ size: CGRect) {
        textModifierBottomConstraint.constant = size.height - view.safeAreaInsets.bottom
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        navigationItem.rightBarButtonItem?.isEnabled = textField.text?.isEmpty == false && !contentTextView.text.isEmpty
    }
    
    @objc private func saveButtonAction() {
        guard let record = record else { return }
        
        record.setTitle(titleTextField.text ?? "")
        record.setText(contentTextView.text)
        
        RecordDataProvider.shared.add(record)
        navigationController?.popViewController(animated: true)
    }
}

extension CreateRecordViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        title = "\(textView.text.count)/1000"
        contentTextViewPlaceholderLabel.isHidden = !textView.text.isEmpty
        navigationItem.rightBarButtonItem?.isEnabled = !textView.text.isEmpty && titleTextField.text?.isEmpty == false
    }
}
