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

    private var config: [TabBarViewControllerConfig] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().backgroundColor = .tabBarGray
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .gray
        
        LanguageManager.shared.addReloadCommands([DoneCommand({ [weak self] in
            self?.updateTabBar()
        })])
    }
    
    func setupVCs(_ config: [TabBarViewControllerConfig]) {
        self.config = config
        
        viewControllers = config.map({
            let vc = $0.controller
            
            vc.tabBarItem.title = $0.tabBarItemTitle.localized
            vc.tabBarItem.image = $0.tabBarItemImage
            vc.tabBarItem.imageInsets = $0.imageInset
            
            return vc
        })
    }
    
    func updateTabBar() {
        guard let controllers = viewControllers else { return }
        
        for i in 0..<controllers.count {
            controllers[i].tabBarItem.title = config[i].tabBarItemTitle.localized
        }
    }
    
    deinit {
        print("deinit \(self)")
    }
}
