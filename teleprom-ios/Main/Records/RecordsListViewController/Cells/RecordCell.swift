//
//  RecordCell.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/28/21.
//

import UIKit

class RecordCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    private var record: Record?
    
    func setRecord(_ record: Record) {
        self.record = record
        updateUi()
    }

    private func updateUi() {
        titleLabel.text = record?.title ?? ""
        contentLabel.text = record?.getText()
    }
    
    @IBAction func openRecordAction(_ sender: UIButton) {
        guard let record = record else { return }
        
        let vc = RecordViewController()
        vc.setRecord(record)
        
        findViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
