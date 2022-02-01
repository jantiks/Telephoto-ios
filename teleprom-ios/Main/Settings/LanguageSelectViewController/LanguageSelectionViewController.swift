//
//  LanguageSelectionViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/26/21.
//

import UIKit

class LanguageSelectionViewController: BaseViewController {

    @IBOutlet weak var languageSelectTable: UITableView!
    
    private let tableData: [Languages] = Languages.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()

        languageSelectTable.delegate = self
        languageSelectTable.dataSource = self
        languageSelectTable.register(UINib(nibName: "\(TableViewCellWithLabel.self)", bundle: nil), forCellReuseIdentifier: "LanguageCell")
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func initUI() {
        languageSelectTable.backgroundColor = .tableBgGray
        languageSelectTable.separatorColor = .clear
        languageSelectTable.separatorStyle = .none
        title = "settings.language".localized
    }
}

extension LanguageSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cells = tableView.visibleCells as? [TableViewCellWithLabel] else { return }
        cells.forEach({ $0.setTitleColor(.white) })
        
        cells[indexPath.row].setTitleColor(.telepromPink)
        Languages.setAppLanguage(code: tableData[indexPath.row].rawValue)
        LanguageManager.shared.languageChanged()
        title = "settings.language".localized
    }
}

extension LanguageSelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell") as? TableViewCellWithLabel else { fatalError("Can't find cell with identifier 'LanguageCell'") }
        
        cell.selectionStyle = .none
        cell.titleLabel?.text = tableData[indexPath.row].name
        cell.titleLabel?.textAlignment = .center
        cell.titleLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.setSeparatorColor(.white.withAlphaComponent(0.2))
        
        if indexPath.row == 0 {
            cell.topSeparator.isHidden = true
        } else if indexPath.row == tableData.count - 1 {
            cell.bottomSeparator.isHidden = true
        }
        
        if tableData[indexPath.row].rawValue == Languages.getAppCurrentLanguage() {
            cell.setTitleColor(.telepromPink)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / CGFloat(tableData.count)
    }
}
