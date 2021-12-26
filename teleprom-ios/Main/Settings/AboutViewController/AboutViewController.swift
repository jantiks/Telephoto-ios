//
//  AboutViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/26/21.
//

import UIKit
import StoreKit

class AboutViewController: BaseViewController {

    private var tableData: [String] = []
    
    @IBOutlet private weak var aboutTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        aboutTable.delegate = self
        aboutTable.dataSource = self
        aboutTable.register(UITableViewCell.self, forCellReuseIdentifier: "AboutCell")
        initUI()
    }
    
    private func initUI() {
        setTableData()
        aboutTable.reloadData()
        title = "settings.about".localized
    }
    
    private func setTableData() {
        tableData = [
            "about.user.agreement".localized,
            "about.policy".localized,
            "about.share".localized,
            "about.rate".localized
        ]
    }
}

extension AboutViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else if indexPath.row == 1 {
            
        } else if indexPath.row == 2 {
            
        } else if indexPath.row == 3 {
            SKStoreReviewController.requestReviewFromScene()
        }
    }
}

extension AboutViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell")!
        
        let bgView = UIView()
        bgView.backgroundColor = .tableBgGray
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.cornerRadius = 15
        cell.addSubview(bgView)
        
        bgView.topAnchor.constraint(equalTo: cell.layoutMarginsGuide.topAnchor, constant: 0).isActive = true
        bgView.bottomAnchor.constraint(equalTo: cell.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        bgView.leadingAnchor.constraint(equalTo: cell.layoutMarginsGuide.leadingAnchor, constant: 0).isActive = true
        bgView.trailingAnchor.constraint(equalTo: cell.layoutMarginsGuide.trailingAnchor, constant: 0).isActive = true
        bgView.centerXAnchor.constraint(equalTo: cell.layoutMarginsGuide.centerXAnchor).isActive = true
        
        cell.backgroundColor = .clear
        cell.textLabel?.text = tableData[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = cell.textLabel?.font.withSize(16)
        cell.selectionStyle = .none
        
        return cell
    }
}
