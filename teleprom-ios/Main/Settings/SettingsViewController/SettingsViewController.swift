//
//  SettingsViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/25/21.
//

import UIKit

class SettingsViewController: BaseViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var settingsTableView: UITableView!
    @IBOutlet private weak var subscriptionAdvertizing: SubscriptionAdvertizingView!
    
    private var tableData: [SettingsTableCellConfig] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
        initUI()
        reloadData()
        setReloadCommands()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setReloadCommands() {
        LanguageManager.shared.addReloadCommands([DoneCommand({ [weak self] in
            self?.reloadData()
            self?.subscriptionAdvertizing.languageConfigure()
        })])
        
        IAPManager.shared.addReloadCommands([DoneCommand({ [weak self] in
            self?.subscriptionAdvertizing.isHidden = true
        })])
    }
    
    private func initUI() {
        view.backgroundColor = .controllerGray
        settingsTableView.backgroundColor = .controllerGray
        settingsTableView.separatorColor = .clear
        titleLabel.text = "main.tab.settings".localized
        checkSubscriptionState()
    }
    
    private func checkSubscriptionState() {
        subscriptionAdvertizing.isHidden = IAPManager.shared.getLastSubscribedState()
        IAPManager.shared.checkPermissions { [weak self] hasPermisison in
            self?.subscriptionAdvertizing.isHidden = hasPermisison
        }
    }
    
    private func reloadData() {
        tableData =
        [SettingsTableCellConfig(title: "settings.video.settings".localized, image: UIImage(named: "videoSettings")!),
         SettingsTableCellConfig(title: "settings.language".localized, image: UIImage(named: "language")!),
         SettingsTableCellConfig(title: "settings.help".localized, image: UIImage(named: "help")!),
         SettingsTableCellConfig(title: "settings.about".localized, image: UIImage(named: "about")!)]
        settingsTableView.reloadData()
        titleLabel.text = "main.tab.settings".localized
    }
}
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = VideoSettingsViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = LanguageSelectionViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            let vc = HelpViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 3 {
            let vc = AboutViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell") as? SettingsTableViewCell else { fatalError("Couldn't load SettingsTableView cell") }
        cell.backgroundColor = .clear
        cell.setTitle(tableData[indexPath.row].title)
        cell.setImage(tableData[indexPath.row].image)
        return cell
    }
}
