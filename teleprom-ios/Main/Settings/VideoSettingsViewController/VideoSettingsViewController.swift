//
//  VideoSettingsViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/26/21.
//

import UIKit

class VideoSettingsViewController: BaseViewController {

    @IBOutlet private weak var videoSettingsTable: UITableView!
    @IBOutlet private weak var bottomLabel: UILabel!
    
    private var tableData: [VideoSetting] = VideoSetting.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()

        videoSettingsTable.delegate = self
        videoSettingsTable.dataSource = self
        videoSettingsTable.register(UINib(nibName: "\(TableViewCellWithLabel.self)", bundle: nibBundle), forCellReuseIdentifier: "VideoSettingsCell")

        initUI()
    }
    
    private func initUI() {
        videoSettingsTable.backgroundColor = .tableBgGray
        videoSettingsTable.separatorColor = .clear
        bottomLabel.text = "settings.explantation.label".localized
        title = "settings.video.settings".localized
    }
}

extension VideoSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cells = tableView.visibleCells as? [TableViewCellWithLabel] else { return }
        cells.forEach({ $0.setTitleColor(.white) })
        
        cells[indexPath.row].setTitleColor(.telepromPink)
        UserSettingsManager.shared.setVideoSetting(tableData[indexPath.row])
    }
}

extension VideoSettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoSettingsCell") as? TableViewCellWithLabel else { fatalError("Can't find cell with identifier 'VideoSettingsCell'") }
        
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
        
        if tableData[indexPath.row] == UserSettingsManager.shared.getVideoSetting() {
            cell.setTitleColor(.telepromPink)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / CGFloat(tableData.count)
    }
}
