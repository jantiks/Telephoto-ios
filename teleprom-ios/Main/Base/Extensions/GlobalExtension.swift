//
//  GlobalExtension.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/24/21.
//

import UIKit

func getScene() -> UIWindowScene? {
    return UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
}

func getKeyWindow() -> UIWindow? {
    return getScene()?.windows.first { $0.isKeyWindow }
}

func getController<T: UIViewController>() -> T {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
}

func getTabBar() -> TabBarViewController? {
    return (UIApplication.shared.delegate as? AppDelegate)?.tabBarController
}
