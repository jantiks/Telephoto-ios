//
//  TabBarViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/24/21.
//

import UIKit

class BaseTabBarViewController: UITabBarController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().backgroundColor = .menuColor
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .gray
    }
    
    func setupVCs(_ config: [TabBarViewControllerConfig]) {
        viewControllers = config.map({
            let vc = $0.controller
            
            vc.tabBarItem.title = $0.tabBarItemTitle
            vc.tabBarItem.image = $0.tabBarItemImage
            vc.tabBarItem.imageInsets = $0.imageInset
            
            return vc
        })
    }
}
