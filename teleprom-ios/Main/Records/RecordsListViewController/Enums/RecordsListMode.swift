//
//  RecordsListMode.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/31/21.
//

import Foundation

enum RecordsListMode {
    case add, select
    
    mutating func toggle() {
        switch self {
        case .add:
            self = RecordsListMode.select
        case .select:
            self = RecordsListMode.add
        }
    }
}
