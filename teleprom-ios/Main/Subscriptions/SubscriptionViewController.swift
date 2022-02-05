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
    
    private var loaderView: UIView?
    private var reloadCommands: [CommonCommand] = []
    private let cellHeight: CGFloat = 75
    private let featuresData: [PremiumFeatureConfig] = [
                                                        PremiumFeatureConfig(title: "export.videos.title".localized, subtitle: "export.videos.subtitle".localized),
                                                        PremiumFeatureConfig(title: "turn.off.ads.title".localized, subtitle: "turn.off.ads.subtitle".localized),
                                                        PremiumFeatureConfig(title: "apsect.ratio.title".localized, subtitle: "apsect.ratio.subtitle".localized)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    func addReloadCommands(_ commands: [CommonCommand]) {
        reloadCommands.append(contentsOf: commands)
    }
    
    private func initUI() {
        view.backgroundColor = .white
        
        languageConfigure()
        setTableView()
    }
    
    private func setTableView() {
        premiumFeaturesTableView.backgroundColor = .white
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
    
    private func showLoader() {
        loaderView = UIView()
        loaderView?.frame = view.frame
        loaderView?.backgroundColor = .darkGray.withAlphaComponent(0.5)
        view.addSubview(loaderView!)
        
        // activity indicator
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.startAnimating()
        loaderView?.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: loaderView!, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: loaderView!, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
    }
    
    private func hideLoader() {
        loaderView?.removeFromSuperview()
    }
    
    private func getSuccessRestoreAlert() -> UIViewController {
        let ac = UIAlertController(title: "restore.success.title".localized, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        return ac
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func subscribeAction(_ sender: UIButton) {
        showLoader()
        IAPManager.shared.purchase(product: SubscriptionType.weekly) { [weak self] completed in
            if completed  {
                self?.reloadCommands.forEach({ $0.execute() })
                self?.dismiss(animated: true)
            }
            
            self?.hideLoader()
        }
    }
    
    @IBAction func restoreAction(_ sender: UIButton) {
        showLoader()
        IAPManager.shared.restore { [weak self] completed in
            guard let self = self else { return }
            
            if completed {
                self.reloadCommands.forEach({ $0.execute() })
                self.dismiss(animated: true)
                AppDelegate.getController()?.present(self.getSuccessRestoreAlert(), animated: true)
            }
            
            self.hideLoader()
        }
    }
    
    @IBAction func privacyAction(_ sender: UIButton) {
        if let url = URL(string: Utils.privacyUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func termsAction(_ sender: UIButton) {
        if let url = URL(string: Utils.termsUrl) {
            UIApplication.shared.open(url)
        }
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
