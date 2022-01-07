//
//  TabBarViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/25/21.
//

import UIKit

class TabBarViewController: BaseTabBarViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVCs([
            TabBarViewControllerConfig(controller: RecordsListViewController(), tabBarItemTitle: "main.tab.records", tabBarItemImage: UIImage(named: "notes")!),
            TabBarViewControllerConfig(controller: CameraCaptureViewController(), tabBarItemTitle: "", tabBarItemImage: UIImage(named: "rec")!.withRenderingMode(.alwaysOriginal), imageInset: UIEdgeInsets(top: -8, left: 0, bottom: 8, right: 0)),
            TabBarViewControllerConfig(controller: SettingsViewController(), tabBarItemTitle: "main.tab.settings", tabBarItemImage: UIImage(named: "settings")!)
        ])
    }
}
