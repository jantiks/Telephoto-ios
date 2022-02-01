//
//  AspectRationCellConfig.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 1/16/22.
//

import CoreGraphics
import Foundation

class AspectRatioCellConfig {
    let title: String
    let aspectRatio: CGSize
    let aspectRatioDescription: String
    let selectAction: (IndexPath) -> ()
    var isSelected: Bool
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    init(title: String, aspectRatio: CGSize, aspectRatioDescription: String, selectAction: @escaping (IndexPath) -> (), isSelected: Bool = false) {
        self.title = title
        self.aspectRatio = aspectRatio
        self.aspectRatioDescription = aspectRatioDescription
        self.selectAction = selectAction
        self.isSelected = isSelected
    }
}
