//
//  OnboardingViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/24/22.
//

import UIKit

class OnboardingViewController: BaseViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var continueButton: UIButton!
    
    private let maxPageCount = 1
    
    private func getCurrentPage() -> Int {
        
        print("CURRENT PAGE \(Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width))))")
        return Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
    }
    
    private func presentTabBar() {
        let tabBar = TabBarViewController()
        let home = BaseNavigationController(rootViewController: tabBar)
        (UIApplication.shared.delegate as? AppDelegate)?.tabBarController = tabBar
        home.modalPresentationStyle = .fullScreen
        present(home, animated: true)
        
        UserDefaults.standard.set(true, forKey: "UserHasSeenOnboarding")
    }

    @IBAction func continueAction(_ sender: UIButton) {
        // changing to new page
        let currentPage = getCurrentPage()
        
        if currentPage >= maxPageCount {
            presentTabBar()
        } else {
            scrollView.setContentOffset(CGPoint(x: scrollView.bounds.width * CGFloat(currentPage + 1), y: 0), animated: true)
        }
    }
}
