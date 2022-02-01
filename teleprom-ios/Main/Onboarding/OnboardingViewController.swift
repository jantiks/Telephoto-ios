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
    
    // first page top labels
    @IBOutlet weak var firstTitleLabel: UILabel!
    @IBOutlet weak var firstSubtitle: UILabel!
    @IBOutlet weak var secondSubtitle: UILabel!
    @IBOutlet weak var thirdSubtitle: UILabel!
    
    // first page bottom labels
    @IBOutlet weak var secondTitleLabel: UILabel!
    @IBOutlet weak var fifthSubtitle: UILabel!
    @IBOutlet weak var sixthSubtitle: UILabel!
    @IBOutlet weak var seventhSubtitle: UILabel!
    @IBOutlet weak var eightSubtitle: UILabel!
    
    // secnod page labels
    @IBOutlet weak var thirdTitleLabel: UILabel!
    @IBOutlet weak var welcomeDescription: UILabel!
    
    private let maxPageCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languageConfigure()
    }
    
    private func languageConfigure() {
        firstTitleLabel.text = "how.it.works".localized
        firstSubtitle.text = "tap.subtitle".localized
        secondSubtitle.text = "press.subtitle".localized
        thirdSubtitle.text = "change.subtitle".localized
        
        secondTitleLabel.text = "it.is.nice.choice".localized
        fifthSubtitle.text = "youtube.subtitle".localized
        sixthSubtitle.text = "broadcaster.subtitle".localized
        seventhSubtitle.text = "business.subtitle".localized
        eightSubtitle.text = "tv.subtitle".localized
        
        thirdTitleLabel.text = "welcome.title".localized
        welcomeDescription.text = "welcome.subtitle".localized
        
        continueButton.setTitle("continue".localized, for: .normal)
    }
    
    private func getCurrentPage() -> Int {
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
