//
//  UITabBarControllerExtension.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/9/22.
//

import UIKit

extension UITabBarController {
    func orderedTabBarItemViews() -> [UIView] {
        let interactionViews = tabBar.subviews.filter({$0.isUserInteractionEnabled})
        return interactionViews.sorted(by: {$0.frame.minX < $1.frame.minX})
    }
}
