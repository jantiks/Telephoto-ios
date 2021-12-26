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
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
