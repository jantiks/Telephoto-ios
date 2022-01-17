//
//  AspectRatioViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/16/22.
//

import UIKit

class AspectRatioViewController: BaseViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var selectButton: UIButton!
    @IBOutlet private weak var aspectRatiosTableView: UITableView!
    
    var setAspectRatioAction: ((CGSize) -> ())?
    private var aspectRatiosConfigs: [AspectRatioCellConfig] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        setDelegates()
        reloadData()
        initUI()
    }
    
    private func registerCells() {
        aspectRatiosTableView.register(UINib(nibName: "\(AspectRationCell.self)", bundle: nil), forCellReuseIdentifier: "AspectRatioCell")
    }
    
    private func setDelegates() {
        aspectRatiosTableView.delegate = self
        aspectRatiosTableView.dataSource = self
    }

    private func reloadData() {
        aspectRatiosConfigs = [
            AspectRatioCellConfig(title: "standart".localized, aspectRatio: CGSize(width: 9, height: 16), aspectRatioDescription: "", selectAction: selectCellAction),
            AspectRatioCellConfig(title: "Instagram", aspectRatio: CGSize(width: 1, height: 1), aspectRatioDescription: "aspect.ratio.instagram.story".localized, selectAction: selectCellAction),
            AspectRatioCellConfig(title: "TikTok", aspectRatio: CGSize(width: 9, height: 16), aspectRatioDescription: "aspect.ratio.publication".localized, selectAction: selectCellAction),
            AspectRatioCellConfig(title: "Twitter", aspectRatio: CGSize(width: 9, height: 16), aspectRatioDescription: "aspect.ratio.publication".localized, selectAction: selectCellAction),
                                ]
        aspectRatiosTableView.reloadData()
    }

    private func initUI() {
        titleLabel.text = "aspect.ratio.title".localized
        setSelectButton()
    }
    
    private func setSelectButton() {
        if aspectRatiosConfigs.contains(where: { $0.isSelected }) {
            selectButton.setTitle("records.mode.select.button.title".localized, for: .normal)
            selectButton.setTitleColor(.telepromPink, for: .normal)
        } else {
            selectButton.setTitle("records.mode.cancel.button.title".localized, for: .normal)
            selectButton.setTitleColor(.white, for: .normal)
        }
    }
    
    private func selectCellAction(_ indexPath: IndexPath) {
        if let selectedConfig = aspectRatiosConfigs.first(where: { $0.isSelected && $0.indexPath.row != indexPath.row }) {
            selectedConfig.isSelected = false
            aspectRatiosTableView.reloadRows(at: [selectedConfig.indexPath], with: .automatic)
        }
        
        setSelectButton()
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        if let aspectRatio = aspectRatiosConfigs.first(where: { $0.isSelected })?.aspectRatio {
            setAspectRatioAction?(aspectRatio)
            dismiss(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}

extension AspectRatioViewController: UITableViewDelegate {
    
}

extension AspectRatioViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aspectRatiosConfigs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AspectRatioCell", for: indexPath) as? AspectRationCell else { fatalError() }
        
        cell.selectionStyle = .none
        aspectRatiosConfigs[indexPath.row].indexPath = indexPath
        cell.setConfig(aspectRatiosConfigs[indexPath.row])
        
        
        return cell
    }
}
