//
//  RecordViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/29/21.
//

import UIKit

class RecordViewController: BaseViewController {

    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var contentTextView: UITextView!
    @IBOutlet private weak var backgroundView: UIView!
    
    private var record: Record?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if record == nil {
            record = Record()
        }
        
        contentTextView.delegate = self
        initUI()
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
    
    private func initUI() {
        titleTextField.text = record?.title
        contentTextView.text = record?.text
        
        title = "\(contentTextView.text.count)/1000"
        
        let rightBarButtonItem = UIBarButtonItem(title: "record.navbar.save".localized, style: .plain, target: self, action: #selector(saveButtonAction))
        rightBarButtonItem.tintColor = .telepromPink
        navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
    }
    
    @objc private func saveButtonAction() {
        guard let record = record else { return }
        
        record.setTitle(titleTextField.text ?? "")
        record.setText(contentTextView.text)
        
        RecordDataProvider.shared.addRecord(record)
        navigationController?.popViewController(animated: true)
    }
}

extension RecordViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        title = "\(textView.text.count)/1000"
    }
}
