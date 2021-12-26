//
//  VideoSetting.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/26/21.
//

import Foundation

enum VideoSetting: CaseIterable {
    
    case hd_720p, hd_1080p, hd_1080p_60fps
    
    init(_ rawValue: Int) {
        switch rawValue {
        case 0:
            self = .hd_720p
        case 1:
            self = .hd_1080p
        case 2:
            self = .hd_1080p_60fps
        default:
            fatalError("WRONG RAW VALUE")
        }
    }
    
    var rawValue: Int {
        get {
            switch self {
            case .hd_720p:
                    return 0
            case .hd_1080p:
                return 1
            case .hd_1080p_60fps:
                return 2
            }
        }
    }
    
    var title: String {
        get {
            switch self {
            case .hd_720p:
                    return "hd.720p".localized
            case .hd_1080p:
                return "hd.1080p".localized
            case .hd_1080p_60fps:
                return "hd.1080p.60fps".localized
            }
        }
    }
}
