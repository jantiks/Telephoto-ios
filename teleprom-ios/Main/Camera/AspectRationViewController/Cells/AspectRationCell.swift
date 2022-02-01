//
//  AspectRationCell.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/16/22.
//

import UIKit

class AspectRationCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var aspectRatioLabel: UILabel!
    @IBOutlet weak var aspectRatioDescriptionLabel: UILabel!
    @IBOutlet weak var aspectRatioView: UIView!
    @IBOutlet weak var aspectRatioWidth: NSLayoutConstraint!
    
    private let defaultHeight: Double = 170
    private weak var config: AspectRatioCellConfig?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateBorderLayer()
    }
    
    func setConfig(_ config: AspectRatioCellConfig) {
        self.config = config
        titleLabel.text = config.title
        aspectRatioLabel.text = "\(Int(config.aspectRatio.width)):\(Int(config.aspectRatio.height))"
        aspectRatioDescriptionLabel.text = config.aspectRatioDescription
        aspectRatioWidth.constant = defaultHeight *  config.aspectRatio.width / config.aspectRatio.height
        updateBorderLayer()
    }
    
    private func updateBorderLayer() {
        aspectRatioView.layer.borderWidth = 2
        aspectRatioView.layer.borderColor = config?.isSelected == true ? UIColor.telepromPink.cgColor : UIColor.clear.cgColor
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        config?.isSelected.toggle()
        updateBorderLayer()
        config?.selectAction(config?.indexPath ?? IndexPath(row: 0, section: 0))
    }
}
