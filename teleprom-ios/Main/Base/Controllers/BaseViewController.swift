//
//  BaseViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/24/21.
//

import UIKit

class BaseViewController: UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
