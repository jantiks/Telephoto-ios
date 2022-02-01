//
//  SubscriptionViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/21/22.
//

import UIKit

class SubscriptionViewController: BaseViewController {

    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var subscriptionButton: UIButton!
    @IBOutlet private weak var restoreButton: UIButton!
    @IBOutlet private weak var termsButton: UIButton!
    @IBOutlet private weak var privacyButton: UIButton!
    @IBOutlet private weak var premiumFeaturesTableView: UITableView!
    
    private let cellHeight: CGFloat = 75
    private let featuresData: [PremiumFeatureConfig] = [
                                                        PremiumFeatureConfig(title: "export.videos.title".localized, subtitle: "export.videos.subtitle".localized),
                                                        PremiumFeatureConfig(title: "turn.off.ads.title".localized, subtitle: "turn.off.ads.subtitle".localized),
                                                        PremiumFeatureConfig(title: "apsect.ratio.title".localized, subtitle: "apsect.ratio.subtitle".localized)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    private func initUI() {
        view.backgroundColor = .white
        
        languageConfigure()
        setTableView()
    }
    
    private func setTableView() {
        premiumFeaturesTableView.separatorStyle = .none
        premiumFeaturesTableView.isScrollEnabled = false
        premiumFeaturesTableView.delegate = self
        premiumFeaturesTableView.dataSource = self
        
        registerCells()
    }
    
    private func registerCells() {
        premiumFeaturesTableView.register(UINib(nibName: "\(PremiumFeatureCell.self)", bundle: nil), forCellReuseIdentifier: "\(PremiumFeatureCell.self)")
    }
    
    private func languageConfigure() {
        subtitleLabel.text = "with.premium".localized
        descriptionLabel.text = "subscription.description".localized
        subscriptionButton.setTitle("subscribe.now".localized, for: .normal)
        privacyButton.setTitle("privacy".localized, for: .normal)
        restoreButton.setTitle("restore".localized, for: .normal)
        termsButton.setTitle("terms".localized, for: .normal)
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension SubscriptionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}

extension SubscriptionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return featuresData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(PremiumFeatureCell.self)") as? PremiumFeatureCell else { fatalError() }
        
        cell.selectionStyle = .none
        cell.setConfig(featuresData[indexPath.row])
        
        return cell
    }
}
