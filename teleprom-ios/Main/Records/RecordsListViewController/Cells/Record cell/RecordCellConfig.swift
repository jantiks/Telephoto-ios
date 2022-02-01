//
//  RecordCellConfig.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/31/21.
//

import Foundation

class RecordCellConfig {
    let record: Record
    let mode: RecordsListMode
    var isSelected: Bool
    
    init(record: Record, mode: RecordsListMode ,isSelected: Bool = false) {
        self.record = record
        self.mode = mode
        self.isSelected = isSelected
    }
}
