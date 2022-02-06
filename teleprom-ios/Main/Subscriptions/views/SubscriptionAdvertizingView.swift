//
//  SubscriptionAdvertizing.swift
//  teleprom-ios
//
//  Created by Tigran on 02.02.22.
//

import UIKit

class SubscriptionAdvertizingView: BaseCustomView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var advertizingFirstSubtitle: UILabel!
    @IBOutlet private weak var advertizingSecondSubtitle: UILabel!
    @IBOutlet private weak var advertizingThirdSubtitle: UILabel!
    
    override func getContentView() -> UIView {
        return contentView
    }
    
    override func getXibName() -> String {
        return "\(SubscriptionAdvertizingView.self)"
    }
    
    override func commonInit() {
        super.commonInit()
        
        languageConfigure()
    }
    
    func languageConfigure() {
        subtitleLabel.text = "with.premium".localized
        advertizingFirstSubtitle.text = "advertizing.first.subtitle".localized
        advertizingSecondSubtitle.text = "advertizing.second.subtitle".localized
        advertizingThirdSubtitle.text = "advertizing.third.subtitle".localized
    }
    
    @IBAction func subscribeAction(_ sender: UIButton) {
        let vc = SubscriptionViewController()
        vc.modalPresentationStyle = .fullScreen
        AppDelegate.getController()?.present(vc, animated: true)
    }
}
