//
//  AddRecordCell.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/27/21.
//

import UIKit

class AddRecordCell: UICollectionViewCell {

    var addRecordCommand: CommonCommand? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func addRecordAction(_ sender: UIButton) {
        addRecordCommand?.execute()
    }
}
