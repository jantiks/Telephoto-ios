//
//  BaseViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/24/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    private var isVisible: Bool = false
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .controllerGray
        navigationItem.backButtonTitle = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("asd will appear \(self)")
        isVisible = true
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("asd disappear \(self)")
        isVisible = false
    }
    
    func isCurrentlyVisible() -> Bool {
        return isVisible
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.baseKeyboardDidShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.baseKeyboardDidHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func baseKeyboardDidShowNotification(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
                let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
                let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
                let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
                self.keyboardDidShow(keyboardSize)
                UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: { [weak self] in self?.view?.layoutIfNeeded() }, completion: nil)
            
            }
        }
    }
    
    @objc private func baseKeyboardDidHideNotification(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            self.keyboardDidHide()
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve, animations: { [weak self] in self?.view?.layoutIfNeeded() }, completion: nil)
        }
    }
    
    func keyboardDidShow(_ size: CGRect) {
        
    }
    
    func keyboardDidHide() {
        
    }
    
    deinit {
        print("deinit \(self)")
    }
}
