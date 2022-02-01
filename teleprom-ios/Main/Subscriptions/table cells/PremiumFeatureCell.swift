//
//  PremiumFeatureCell.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/22/22.
//

import UIKit

class PremiumFeatureCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    func setConfig(_ config: PremiumFeatureConfig) {
        titleLabel.text = config.title
        subtitleLabel.text = config.subtitle
    }
}
