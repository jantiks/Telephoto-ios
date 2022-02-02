//
//  TabBarViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/25/21.
//

import UIKit

class TabBarViewController: BaseTabBarViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        setupVCs([
            TabBarViewControllerConfig(controller: RecordsListViewController(), tabBarItemTitle: "main.tab.records", tabBarItemImage: UIImage(named: "notes")!),
            TabBarViewControllerConfig(controller: CameraCaptureViewController(), tabBarItemTitle: "", tabBarItemImage: UIImage(named: "rec")!.withRenderingMode(.alwaysOriginal), imageInset: UIEdgeInsets(top: -8, left: 0, bottom: 8, right: 0)),
            TabBarViewControllerConfig(controller: SettingsViewController(), tabBarItemTitle: "main.tab.settings", tabBarItemImage: UIImage(named: "settings")!)
        ])
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        viewControllers?.forEach({
            ($0 as? TabBarSelectable)?.selectionChanged(selectedController: viewController)
        })
    }
    
    private func initUI() {
        UITabBar.appearance().backgroundColor = .tabBarGray
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .gray
        tabBar.barTintColor = .tabBarGray
        languageConfigure()
        
        LanguageManager.shared.addReloadCommands([DoneCommand({ [weak self] in
            self?.languageConfigure()
        })])
    }
    
    private func languageConfigure() {
        navigationItem.backButtonTitle = "back".localized
    }
}
