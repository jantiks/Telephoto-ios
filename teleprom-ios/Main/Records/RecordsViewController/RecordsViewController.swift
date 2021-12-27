//
//  RecordsViewController.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/27/21.
//

import UIKit

class RecordsViewController: BaseViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var recordsCollectionView: UICollectionView!
    @IBOutlet private weak var selectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func initUI() {
        selectButton.setTitleColor(.telepromPink, for: .normal)
        reloadData()
    }
    
    private func reloadData() {
        recordsCollectionView.reloadData()
        titleLabel.text = "main.tab.new.records".localized
        selectButton.setTitle("records.select.button.title".localized, for: .normal)
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
    }
}
