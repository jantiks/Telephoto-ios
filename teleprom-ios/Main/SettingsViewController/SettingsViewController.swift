//
//  SettingsViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/25/21.
//

import UIKit

class SettingsViewController: BaseViewController {
    
    @IBOutlet private weak var settingsTableView: UITableView!
    
    private var tableData: [SettingsTableCellConfig] =
        [SettingsTableCellConfig(title: "settings.video.settings".localized, image: UIImage(named: "videoSettings")!),
         SettingsTableCellConfig(title: "settings.language".localized, image: UIImage(named: "language")!),
         SettingsTableCellConfig(title: "settings.help".localized, image: UIImage(named: "help")!),
         SettingsTableCellConfig(title: "settings.about".localized, image: UIImage(named: "about")!)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingsTableViewCell")
        
        initUI()
    }
    
    private func initUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "main.tab.settings".localized
        
        view.backgroundColor = .customDarkGray
        settingsTableView.backgroundColor = .customDarkGray
        settingsTableView.separatorColor = .clear
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row
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
