//
//  AddRecordCell.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/27/21.
//

import UIKit

class AddRecordCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cornerRadius = 20
        backgroundColor = .tableBgGray
    }
    
    @IBAction func addRecordAction(_ sender: UIButton) {
        let vc = CreateRecordViewController()
        
        findViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
