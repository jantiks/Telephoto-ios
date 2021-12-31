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
    
    private var config: RecordCellConfig?
    var setSelectedCommand: CommonCommand?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cornerRadius = 20
        backgroundColor = .tableBgGray
        updateBorderLayer()
    }
    
    func configure(_ config: RecordCellConfig) {
        self.config = config
        
        titleLabel.text = config.record.title
        contentLabel.text = config.record.getText()
        updateBorderLayer()
    }

    private func updateBorderLayer() {
//        layer.borderWidth = 1
//        layer.borderColor = config?.isSelected == true ? UIColor.telepromPink.cgColor : UIColor.clear.cgColor
        
        backgroundColor = config?.isSelected == true ? UIColor.telepromPink : UIColor.tableBgGray
    }
    
    private func setSelected() {
        setSelectedCommand?.execute()
        config?.isSelected.toggle()
        updateBorderLayer()
    }
    
    private func pushRecordsViewController() {
        guard let record = config?.record else { return }
        
        let vc = CreateRecordViewController()
        vc.setRecord(record)
        
        findViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapAction(_ sender: UIButton) {
        if config?.mode == .add {
            pushRecordsViewController()
        } else {
            setSelected()
        }
    }
}
