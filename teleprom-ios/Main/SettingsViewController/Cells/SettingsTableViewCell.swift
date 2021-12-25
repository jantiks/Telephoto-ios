//
//  SettingsTableViewCell.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/25/21.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setImage(_ image: UIImage) {
        mainImageView.image = image
    }
}
