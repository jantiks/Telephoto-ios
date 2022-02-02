//
//  BaseNavigationController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/25/21.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .controllerGray
        navigationBar.barTintColor = .controllerGray
        navigationBar.isTranslucent = true
        navigationBar.tintColor = .white
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        LanguageManager.shared.addReloadCommands([DoneCommand({ [weak self] in
            self?.languageConfigure()
        })])
    }
    
    private func languageConfigure() {
        navigationItem.backButtonTitle = "back".localized
    }
    
    deinit {
        print("deinit \(self)")
    }
}

extension UINavigationController {
    func setNavigationBarTransparent() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
}
