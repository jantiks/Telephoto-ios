//
//  TableViewCellWithLabel.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/26/21.
//

import UIKit

class TableViewCellWithLabel: UITableViewCell {

    @IBOutlet weak var topSeparator: UIView!
    @IBOutlet weak var bottomSeparator: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
    }
    
    func setSeparatorColor(_ color: UIColor) {
        topSeparator.backgroundColor = color
        bottomSeparator.backgroundColor = color
    }
    
    func setTitleColor(_ color: UIColor) {
        titleLabel.textColor = color
    }
}
