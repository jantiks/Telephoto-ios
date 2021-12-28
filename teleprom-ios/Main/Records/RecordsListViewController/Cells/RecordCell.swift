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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setRecord(_ record: Record) {
        self.record = record
        updateUi()
    }

    private func updateUi() {
        titleLabel.text = record?.title ?? ""
        contentLabel.text = record?.text ?? ""
    }
}
