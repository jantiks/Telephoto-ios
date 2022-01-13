//
//  VideoSetting.swift
//  teleprom-ios
//
//  Created by Tigran Arsenyan on 12/26/21.
//

import Foundation
import AVFoundation

enum VideoSetting: Int, CaseIterable {
    
    case hd_720p, hd_1080p, hd_1080p_60fps
        
    init(_ rawValue: Int) {
        switch rawValue {
        case VideoSetting.hd_720p.rawValue:
            self = .hd_720p
        case VideoSetting.hd_1080p.rawValue:
            self = .hd_1080p
        case VideoSetting.hd_1080p_60fps.rawValue:
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
    
    var name: String {
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
    
    var fps: Int {
        switch self {
        case VideoSetting.hd_720p:
            return 30
        case VideoSetting.hd_1080p:
            return 30
        case VideoSetting.hd_1080p_60fps:
            return 60
        }
    }
    
    var preset: AVCaptureSession.Preset {
        switch self {
        case VideoSetting.hd_720p:
            return .hd1280x720
        case VideoSetting.hd_1080p:
            return .hd1920x1080
        case VideoSetting.hd_1080p_60fps:
            return .hd1920x1080
        }
    }
}
